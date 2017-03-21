module CraigMon::Models
  class URL

    def self.get : String | Nil
      CraigMon.db.query_one? "SELECT url FROM urls limit 1", as: { String }
    end

    def self.update(url : String)
      id = CraigMon.db.query_one? "SELECT id FROM urls limit 1", as: { Int32 }
      if id
        CraigMon.db.exec "UPDATE urls SET url=? WHERE id=?", url, id
      else
        CraigMon.db.exec "INSERT INTO urls (id, name, url) VALUES (?, ?, ?)", 1, "default", url
      end
    end

  end
end
