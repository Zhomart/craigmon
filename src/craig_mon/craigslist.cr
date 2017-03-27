module CraigMon
  module Craigslist
    extend self

    alias ValueType = Int32 | String


    def norm_search_uri_rss(url : String, s : ValueType? = nil, sort : ValueType? = nil) : URI
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

    # Returns picture urls
    def get_pictures(item_url : String) : Array(String)
      item_url = item_url.gsub("http://", "https://")
      res = HTTP::Client.get(item_url)
      pictures = [] of String
      if res.status_code != 200
        CraigMon.logger.warn "Item not found #{item_url} | code=#{res.status_code}"
        return pictures
      end
      html = XML.parse_html(res.body)
      thumbs = html.xpath(%(//div[@id="thumbs"])).as(XML::NodeSet)
      return pictures if thumbs.size == 0
      thumbs[0].children.each do |pic|
        pictures << pic["href"] if pic.name == "a"
      end
      pictures
    end


  end
end
