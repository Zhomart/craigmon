require "option_parser"
require "http/client"

module CraigMon
  class Worker
    SLEEP = 10

    def self.run
      OptionParser.parse! do |parser|
        parser.banner = "Usage: craigmon worker [arguments]"
        parser.on("-d", "--debug", "debug mode") { CraigMon.logger.level = Logger::DEBUG }
        parser.on("-q", "--quiet", "quiet mode") { CraigMon.logger.level = Logger::WARN }
        parser.on("-h", "--help", "Show this help") {
          puts parser
          exit 0
        }
      end

      CraigMon.logger.info "Running worker"
      worker = self.new()
      loop do
        started_at = Time.now
        worker.process()
        CraigMon.logger.debug "Finished in #{Time.now - started_at}. Sleeping for #{SLEEP} seconds"
        sleep SLEEP
      end
    end

    def process
      url = Models::URL.get
      return when_url_nil() if url.nil? || url.empty?

      vanished = Set(Int64).new
      Crecto::Repo.all(Models::Item, Crecto::Repo::Query.where("vanished_at is null")).each do |item|
        vanished << item.uid.as(Int64)
      end

      get_from_craigslist(url, max_page: 5) do |page, values|
        CraigMon.logger.debug "Updating items on page #{page}"
        values.each do |value|
          uid = Int64.new(value["id"])
          if uid == "6058686496"
            p uid
            p value[:title]
            p Models::Item.find_by?(uid: uid)
          end
          if item = Models::Item.find_by?(uid: uid)
            if item.vanished_at
              Crecto::Repo.update_all(Models::Item, Crecto::Repo::Query.where(uid: uid), { vanished_at: nil })
            end
            vanished.delete(uid)
          else
            item = Models::Item.from_rss(value)
            item.search_url = url
            Crecto::Repo.insert(item)
          end
        end
      end # get_from_craigslist

      now = Time.utc_now
      vanished_count = 0
      vanished.each do |uid|
        query = Crecto::Repo::Query.where(uid: uid).where(vanished_at: nil)
        vanished_count += Crecto::Repo.update_all(Models::Item, query, { vanished_at: now }).as(DB::ExecResult).rows_affected
      end

      CraigMon.logger.debug "new vanished uids #{vanished_count}"
    end

    private def get_from_craigslist(url, max_page = 1, &block)
      uri = URI.parse(url)
      params = uri.query.to_s.split("&")
      [/sort=/, /format=/, /s=/].each do |rem|
        if idx = params.index { |v| v.match(rem) }
          params.delete_at(idx)
        end
      end
      params << "format=rss"
      params << "sort=date"
      s = 0
      (0...max_page).each do |page|
        _params = params.dup
        _params << "s=#{s}"
        uri.query = _params.join("&")
        response = HTTP::Client.get(uri)
        break when_http_error(response) if response.status_code != 200
        rss = RSS.parse(response.body)
        values = rss.craigslist_items
        yield(page, values)
        s += values.size
        sleep 3 + rand(6)
      end
    end

    private def when_url_nil
      CraigMon.logger.warn "url is nil"
    end

    private def when_http_error(response)
      CraigMon.logger.warn "http get error, code=#{response.status_code}"
    end

  end
end
