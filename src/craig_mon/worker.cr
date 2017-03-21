require "http/client"

module CraigMon
  class Worker

    def self.run
      CraigMon.logger.info "Running worker"
      worker = self.new()
      loop do
        worker.process()
        sleep 30
      end
    end

    def process
      url = Models::URL.get
      return when_url_nil() if url.nil?
      uri = URI.parse(url)
      params = uri.query.to_s.split("&")
      params << "format=rss" unless params.includes?("format=rss")
      uri.query = params.join("&")
      response = HTTP::Client.get(uri)
      return when_http_error(response) if response.status_code != 200
      rss = RSS.parse(response.body)

      CraigMon.logger.info "Setting vanished_at to all items"
      Models::Item.set_vanished_all!

      CraigMon.logger.info "Updating all items"
      values = rss.craigslist_items
      values.each do |value|
        id = Int64.new(value["id"])
        unless item = Models::Item.find?(id)
          item = Models::Item.new(id, value["title"], value["link"])
          item.description = value["description"]
          item.date = Time.parse(value["date"], "%FT%X%z", Time::Kind::Local)
          item.issued = Time.parse(value["issued"], "%FT%X%z", Time::Kind::Local)
          item.search_url = url
        end
        item.vanished_at = nil
        item.save
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
