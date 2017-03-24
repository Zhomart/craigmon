require "../../spec_helper"

alias Item = CraigMon::Models::Item

private def build_item
  item = Item.new
  item.id = rand(100_000).to_i64
  item.title = Faker::Lorem.sentence
  item.link = Faker::Internet.url("craigslist.com")
  item.date = Time.now - Time::Span.new(rand(10), 0, 0, 0)
  item.issued = Time.now - Time::Span.new(rand(10), 0, 0, 0)
  item
end

describe CraigMon::Models::Item do

  describe ".all" do
    it "returns all items in DB ordered by date DESC" do
      SpecHelper.setup
      Item.create_table
      Item.delete
      items = [build_item, build_item, build_item, build_item]
      items.map(&.save)
      sorted_dates = items.map(&.date).sort.reverse
      Item.all.map(&.date).zip(sorted_dates).each { |a,b|
        (a-b).should be < Time::Span.new(0, 0, 1)
      }
    end
  end

  describe ".set_vanished_all!" do
    it "sets vanished_at for all items" do
      SpecHelper.setup
      Item.create_table
      Item.delete
      a, b = build_item, build_item
      b.vanished_at = Time.now - 10
      a.save
      b.save
      Item.set_vanished_all!
      Item.find(a.id).vanished_at.should_not eq nil
      diff = Item.find(b.id).vanished_at.as(Time) - b.vanished_at.as(Time)
      diff.should be < Time::Span.new(0, 0, 1)
    end
  end

end
