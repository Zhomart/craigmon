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
      uri = URI.parse(url)
      params = uri.query.to_s.split("&")
      params << "format=rss" unless params.includes?("format=rss")
      uri.query = params.join("&")
      response = HTTP::Client.get(uri)
      return when_http_error(response) if response.status_code != 200
      rss = RSS.parse(response.body)

      vanished = Set(Int64).new

      Crecto::Repo.all(Models::Item, Crecto::Repo::Query.where("vanished_at is not null")).each do |item|
        vanished << item.uid.as(Int64)
      end

      CraigMon.logger.info "Updating all items"
      values = rss.craigslist_items
      values.each do |value|
        uid = Int64.new(value["id"])
        if item = Models::Item.find_by?(uid: uid)
          vanished.delete(uid)
        else
          item = Models::Item.new
          item.uid = uid
          item.title = value["title"]
          item.link = value["link"]
          item.description = value["description"]
          item.date = Time.parse(value["date"], "%FT%X%z").to_utc
          item.issued = Time.parse(value["issued"], "%FT%X%z").to_utc
          item.search_url = url
          Crecto::Repo.insert(item)
        end
      end

      now = Time.utc_now
      vanished.each do |uid|
        query = Crecto::Repo::Query.where(uid: uid)
        Crecto::Repo.update_all(Models::Item, query, { vanished_at: now })
      end

      CraigMon.logger.debug "new vanished uids #{vanished.size}"
      p vanished
    end

    private def when_url_nil
      CraigMon.logger.warn "url is nil"
    end

    private def when_http_error(response)
      CraigMon.logger.warn "http get error, code=#{response.status_code}"
    end

  end
end
