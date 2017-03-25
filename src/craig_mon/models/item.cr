module CraigMon::Models
  class Item < Crecto::Model
    alias Repo = Crecto::Repo

    schema "items" do
      field :uid, Int64
      field :title, String
      field :link, String
      field :description, String
      field :date, Time
      field :issued, Time
      field :vanished_at, Time
      field :comment, String
      field :picture_urls, String
      field :search_url, String
      field :price, Float32

      belongs_to :search, Search
    end

    #
    # ```
    #   Item.find_by?(uid: 12345)
    # ```
    def self.find_by?(**wheres) : Item?
      all = Repo.all(self, Repo::Query.where(**wheres))
      return nil if all.empty?
      all.first
    end

    def self.all_for(search_id, order_by = "date DESC", offset = 0, limit : Int32 | Nil = nil) : Array(Item)
      col, order = order_by.split(" ")
      query = Repo::Query.where(search_id: search_id).order_by(order_by)
      query = query.limit(limit).offset(offset) if limit
      Repo.all(self, query)
    end

    def self.total_count : Int32
      Repo.aggregate(self, :count, :id).as(Int64).to_i32
    end

    def self.from_rss(value : Hash(String, String)) : Item
      item = Models::Item.new
      item.uid = Int64.new(value["id"])
      item.title = value["title"]
      item.link = value["link"]
      item.description = value["description"]
      item.date = Time.parse(value["date"], "%FT%X%z").to_utc
      item.issued = Time.parse(value["issued"], "%FT%X%z").to_utc
      if re = value["title"].match(/&#x0024;(\d+)/)
        item.price = re[1].to_f32
      end
      item
    end

  end
end
