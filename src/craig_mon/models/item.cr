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

    def self.all(order_by = "date DESC") : Array(Item)
      col, order = order_by.split(" ")
      query = Repo::Query.order_by(order_by)
      Repo.all(self, query)
    end

  end
end
