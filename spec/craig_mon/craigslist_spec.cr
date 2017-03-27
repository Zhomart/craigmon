require "../spec_helper"

alias Craigslist = CraigMon::Craigslist

describe CraigMon::Craigslist do

  describe ".get_pictures" do
    it "returns pictures urls" do
      WebMock.wrap do
        url = "https://sfbay.craigslist.org/scz/vgm/6046745501.html"
        WebMock.stub(:get, url).to_return(File.read("spec/fixtures/craiglist-item.html"))
        p Craigslist.get_pictures(url)
      end
    end
  end

end
