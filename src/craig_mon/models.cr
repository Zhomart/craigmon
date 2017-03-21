require "./models/*"

module CraigMon
  module Models

    def self.prepare
      ensure_table("urls", [
        "id int primary key",
        "name varchar(30)",
        "url varchar(255)"
      ])

      ensure_table("items", [
        "id BIGINT primary key", "title varchar(128)", "link varchar(128)",
        "description TEXT",
        "date datetime",
        "issued datetime",
        "vanished_at datetime",
        "updated_at datetime",
        "comment TEXT",
        "picture_urls TEXT",
        "search_url varchar(255)"
      ])
    end

    def self.ensure_table(name : String, cols : Array(String))
      CraigMon.db.exec "CREATE TABLE IF NOT EXISTS #{name} (#{cols.join(", ")})"
    end

  end
end
