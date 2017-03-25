require "../../spec_helper"

alias Item = CraigMon::Models::Item

describe CraigMon::Models::Item do

  describe ".all_for(search_id)" do
    it "returns all items in DB ordered by date DESC" do
      SpecHelper.setup
      Crecto::Repo.delete_all(Item)
      search = create_search
      create_item { |i| i.search = create_search }
      items = [build_item, build_item, build_item, build_item]
      items.map { |i| i.search = search; Crecto::Repo.insert(i) }
      sorted_dates = items.map { |i| i.date.as(Time) }.sort.reverse
      Item.all_for(search.id).size.should eq 4
      Item.all_for(search.id).map { |i| i.date.as(Time) }.zip(sorted_dates).each { |a,b|
        (a - b).should be < Time::Span.new(0, 0, 1)
      }
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
