require "../spec_helper"

alias Craigslist = CraigMon::Craigslist

describe CraigMon::Craigslist do
  describe ".pictures" do
    it "returns pictures urls" do
      WebMock.wrap do
        url = "https://sfbay.craigslist.org/scz/vgm/6046745501.html"
        WebMock.stub(:get, url).to_return(File.read("spec/fixtures/craiglist-item.html"))
        cl = Craigslist.new(url)
        cl.pictures.size.should eq 3
      end
    end
  end # .pictures

  describe ".description" do
    it "returns pictures urls" do
      WebMock.wrap do
        url = "https://sfbay.craigslist.org/scz/vgm/6046745501.html"
        WebMock.stub(:get, url).to_return(File.read("spec/fixtures/craiglist-item.html"))
        cl = Craigslist.new(url)
        cl.description.should contain("XBOX")
      end
    end
  end # .description

  describe ".attrgroup" do
    it "returns pictures urls" do
      WebMock.wrap do
        url = "https://sfbay.craigslist.org/scz/vgm/6046745501.html"
        WebMock.stub(:get, url).to_return(File.read("spec/fixtures/craiglist-item.html"))
        cl = Craigslist.new(url)
        cl.attrgroup.should contain("condition: like new")
      end
    end
  end # .attrgroup

end
