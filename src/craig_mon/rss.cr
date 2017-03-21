require "xml"

module CraigMon
  class RSS

    getter xml : XML::Node

    alias Value = Hash(String, String)

    def initialize(@xml : XML::Node)
    end

    def self.parse(doc : String)
      self.new(XML.parse(doc))
    end

    def craigslist_items : Array(Value)
      items = [] of Value
      xml.children[0].children.each do |item|
        next if item.name != "item"
        value = Value.new
        item.children.each do |c|
          next if c.name == "text"
          value[c.name] = c.text
        end
        if md = value["link"].match(/(\d+)\.html$/)
          value["id"] = md[1]
        else
          next
        end
        items << value
      end
      items
    end

  end
end
