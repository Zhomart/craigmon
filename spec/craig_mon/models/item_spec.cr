require "../../spec_helper"

alias Item = CraigMon::Models::Item

private def build_item
  item = Item.new
  item.uid = 10_000_000_000 + rand(100_000).to_i64
  item.title = Faker::Lorem.sentence
  item.link = Faker::Internet.url("craigslist.com")
  item.date = Time.utc_now - Time::Span.new(rand(10), 0, 0, 0)
  item.issued = Time.utc_now - Time::Span.new(rand(10), 0, 0, 0)
  item.search_url = "https://craigslist.com/search"
  item
end

describe CraigMon::Models::Item do

  describe ".all" do
    it "returns all items in DB ordered by date DESC" do
      SpecHelper.setup
      Crecto::Repo.delete_all(Item)
      items = [build_item, build_item, build_item, build_item]
      items.map { |i| Crecto::Repo.insert(i) }
      sorted_dates = items.map { |i| i.date.as(Time) }.sort.reverse
      Item.all.size.should eq 4
      Item.all.map { |i| i.date.as(Time) }.zip(sorted_dates).each { |a,b|
        (a - b).should be < Time::Span.new(0, 0, 1)
      }
    end
  end

  describe ".set_vanished_all!" do
    it "sets vanished_at for all items" do
      SpecHelper.setup
      Crecto::Repo.delete_all(Item)
      a, b = build_item, build_item
      b.vanished_at = Time.utc_now - 10
      a, b = {a, b}.map { |i| Crecto::Repo.insert(i).instance }
      Item.set_vanished_all!
      Item.find_by?(uid: a.uid).as(Item).vanished_at.should_not eq nil
      diff = Item.find_by?(uid: b.uid).as(Item).vanished_at.as(Time) - b.vanished_at.as(Time)
      diff.should be < Time::Span.new(0, 0, 1)
    end
  end

  describe ".find_by?" do
    it "returns nil if not found" do
      SpecHelper.setup
      Crecto::Repo.delete_all(Item)
      Item.find_by?(uid: 100).should be nil
    end
  end

end
