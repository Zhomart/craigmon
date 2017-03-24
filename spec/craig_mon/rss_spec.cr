require "../spec_helper"

alias RSS = CraigMon::RSS

describe CraigMon::RSS do

  describe "#craigslist_items" do
    it "returns items as XML::Node" do
      rss_str = File.read(SpecHelper.root + "/spec/fixtures/example.xml")
      rss = RSS.parse(rss_str)
      items = rss.craigslist_items
      items.size.should eq 25
      items[0]["id"].should eq "6024913562"
    end
  end

end
