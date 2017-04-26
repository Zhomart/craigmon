module CraigMon
  class Craigslist
    alias ValueType = Int32 | String

    getter raw : String?

    def initialize(@item_url : String)
      download()
    end

    def download
      CraigMon.logger.warn "Downloading item #{@item_url}"
      item_url = @item_url.gsub("http://", "https://")
      res = HTTP::Client.get(item_url)
      pictures = [] of String
      if res.status_code != 200
        CraigMon.logger.warn "Item not found #{item_url} | code=#{res.status_code}"
        @raw = nil
        return
      end
      @raw = res.body
    end

    def html
      @html ||= (!@raw.nil? && XML.parse_html(@raw.as(String)))
    end

    # Returns picture urls
    def pictures : Array(String)
      pictures = [] of String
      return pictures unless html
      _html = html.as(XML::Node)
      thumbs = _html.xpath(%(//div[@id="thumbs"])).as(XML::NodeSet)
      return pictures if thumbs.size == 0
      thumbs[0].children.each do |pic|
        pictures << pic["href"] if pic.name == "a"
      end
      pictures
    end

    def description : String
      return "" unless html
      _html = html.as(XML::Node)
      postingbody = _html.xpath(%(//section[@id="postingbody"])).as(XML::NodeSet)[0]
      postingbody.text.gsub(/[\s\r\n]+/, " ").strip
    end

    def attrgroup : String
      return "" unless html
      _html = html.as(XML::Node)
      attrgroup = _html.xpath(%(//p[@class="attrgroup"])).as(XML::NodeSet)[0]
      attrgroup.text.gsub(/[\s\r\n]+/, " ").strip
    end

    def self.norm_search_uri_rss(url : String, s : ValueType? = nil, sort : ValueType? = nil) : URI
      uri = URI.parse(url)
      params = uri.query.to_s.split("&")
      [/sort=/, /format=/, /s=/].each do |rem|
        if idx = params.index { |v| v.match(rem) }
          params.delete_at(idx)
        end
      end
      params << "format=rss"
      params << "sort=#{sort}" if sort
      params << "s=#{s}" if s
      uri.query = params.join("&")
      uri
    end
  end
end
