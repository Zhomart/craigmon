require "option_parser"
require "http/client"

module CraigMon
  class Worker
    alias Repo = Crecto::Repo
    alias Q = Crecto::Repo::Query
    alias Search = Models::Search
    alias Item = Models::Item

    def self.run
      delay = 30
      page_delay = 4
      max_pages = 10

      OptionParser.parse! do |parser|
        parser.banner = "Usage: craigmon worker [arguments]"
        parser.on("-d DELAY", "--delay=DELAY", "delay/sleep in minutes, default is #{delay}") { |v| delay = v.to_i32 }
        parser.on("--page-delay=DELAY", "delay/sleep in seconds, default is #{page_delay}") { |v| page_delay = v.to_i32 }
        parser.on("-m PAGES", "--pages=PAGES", "max pages to crawl, default is #{max_pages}") { |v| max_pages = v.to_i32 }
        parser.on("--debug", "debug mode") { CraigMon.logger.level = Logger::DEBUG }
        parser.on("-q", "--quiet", "quiet mode") { CraigMon.logger.level = Logger::WARN }
        parser.on("-h", "--help", "Show this help") {
          puts parser
          exit 0
        }
      end

      delay_sec = Math.max(delay * 60, 30)
      max_pages = Math.min(max_pages, 50)

      CraigMon.logger.info "Running worker"
      CraigMon.logger.info "  delay_sec=#{delay_sec}"
      CraigMon.logger.info "  max_pages=#{max_pages}"

      worker = self.new(max_pages, delay_sec, page_delay)
      loop do
        started_at = Time.now
        worker.process
        CraigMon.logger.debug "Finished in #{Time.now - started_at}. Sleeping for #{delay_sec} seconds"
        CraigMon.sleep 5
      end
    end

    def initialize(@max_pages : Int32, @delay_sec : Int32, @page_delay : Int32)
    end

    def process
      Repo.all(Search, Q.where("active = 1")).each do |search|
        delay_diff = Time::Span.new(0, 0, @delay_sec + rand(15))
        # next if search.crawled_at && Time.utc_now - search.crawled_at.as(Time) < delay_diff
        begin
          process_search(search)
          Repo.update_all(Search, Q.where(id: search.id), {crawled_at: Time.utc_now})
        rescue e
          CraigMon.logger.warn "Error while processing search #{search.id}. #{search.name} with url #{search.url.inspect}"
          CraigMon.logger.warn e.to_s
          puts e.backtrace.join("\n")
          puts
        end
        CraigMon.sleep @page_delay + rand(7)
      end
    end

    def process_search(search : Search)
      CraigMon.logger.debug "Procsesing search #{search.id}: #{search.name.inspect}"

      # store un-vanished items' ids
      vanished = Set(Int64).new
      Repo.all(Item, Q.where("vanished_at is null").where(search_id: search.id)).each do |item|
        vanished << item.uid.as(Int64)
      end

      last_uid = -1_i64

      url = search.url.as(String)
      get_from_craigslist(url, max_page: @max_pages) do |page, values|
        CraigMon.logger.debug "Updating items on page #{page}"
        uid = -1_i64
        values.each do |value|
          uid = Int64.new(value["id"])
          if item = Item.find_by?(uid: uid)
            if item.vanished_at
              Repo.update_all(Item, Q.where(uid: uid), {vanished_at: nil})
            end
            vanished.delete(uid)
          else
            cl = Craigslist.new(value["link"])
            item = Item.from_rss(value)
            item.search_id = search.id
            item.picture_urls = cl.pictures.join(", ")
            item.description = cl.description
            item.attrgroup = cl.attrgroup
            Repo.insert(item)
          end
        end
        if last_uid == uid || values.size == 0
          CraigMon.logger.debug "Stopping on page #{page} with uid #{uid}"
          break
        end
        last_uid = uid
      end # get_from_craigslist

      now = Time.utc_now
      vanished_count = 0
      vanished.each do |uid|
        query = Crecto::Repo::Query.where(uid: uid).where(vanished_at: nil)
        vanished_count += Crecto::Repo.update_all(Models::Item, query, {vanished_at: now}).as(DB::ExecResult).rows_affected
      end

      CraigMon.logger.debug "new vanished uids #{vanished_count}"
    end

    private def get_from_craigslist(url, max_page = 1, &block)
      s = 0
      (0...max_page).each do |page|
        uri = Craigslist.norm_search_uri_rss(url, s: s, sort: "date")
        response = HTTP::Client.get(uri)
        break when_http_error(response) if response.status_code != 200
        rss = RSS.parse(response.body)
        values = rss.craigslist_items
        yield(page, values)
        s += values.size
        CraigMon.sleep @page_delay + rand(5)
      end
    end

    private def when_http_error(response)
      CraigMon.logger.warn "http get error, code=#{response.status_code}"
    end
  end
end
