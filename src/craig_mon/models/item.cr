require "xml"

module CraigMon::Models
  struct Item
    property id, title, link
    property description : String
    property date : Time | Nil
    property issued : Time | Nil
    property vanished_at : Time | Nil
    property updated_at : Time
    property comment : String
    property picture_urls : String # comma separated
    property search_url : String
    property new_record : Bool

    def initialize(@id : Int64, @title : String, @link : String)
      @description = ""
      @date = nil
      @issued = nil
      @vanished_at = nil
      @updated_at = Time.now
      @comment = ""
      @picture_urls = ""
      @search_url = ""
      @new_record = true
    end

    def self.new(res : DB::ResultSet) : Item
      item = Item.new(res.read(Int64), res.read(String), res.read(String))
      item.description = res.read(String)
      item.date = res.read(Time)
      item.issued = res.read(Time)
      item.vanished_at = res.read(Time)
      item.updated_at = res.read(Time)
      item.comment = res.read(String)
      item.picture_urls = res.read(String)
      item.search_url = res.read(String)
      item.new_record = false
      item
    end

    def save
      if new_record
        CraigMon.logger.info "creating a new record for #{id} | #{date} | #{title}"
        CraigMon.db.exec("INSERT INTO items (id, title, link, description, date, issued, vanished_at,
          updated_at, comment, picture_urls, search_url) VALUES(?,?,?,?,?,?,?,?,?,?,?)",
          id, title, link, description, date, issued, vanished_at, Time.now, comment, picture_urls, search_url)
      else
        CraigMon.logger.debug "updating #{id}"
        CraigMon.db.exec("UPDATE items SET title=?, link=?, description=?, date=?, issued=?, vanished_at=?,
          updated_at=?, comment=?, picture_urls=?, search_url=? WHERE id=?",
          title, link, description, date, issued, vanished_at, Time.now, comment, picture_urls, search_url, id)
      end
      @new_record = false
      true
    end

    def self.find?(id)
      CraigMon.db.query_one? "SELECT id, title, link, description, date, issued, vanished_at,
        updated_at, comment, picture_urls, search_url FROM items WHERE id=? limit 1", id do |val|
        return nil if val.nil?
        self.new(val)
      end
    end

    def self.set_vanished_all!
      now = Time.now
      CraigMon.db.exec "UPDATE items SET vanished_at = ?, updated_at = ? WHERE vanished_at IS NULL", now, now
    end

  end
end
