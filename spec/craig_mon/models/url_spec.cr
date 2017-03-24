require "../../spec_helper"

alias URL = CraigMon::Models::URL

private def create_url(name = "default", url = "http://yay.com")
  url = URL.new
  url.name = "default"
  url.url = "http://yay.cm"
  Crecto::Repo.insert(url)
end

describe CraigMon::Models::URL do

  describe ".get" do
    it "returns nil if DB is empty" do
      SpecHelper.setup
      Crecto::Repo.delete_all(URL)
      URL.get.should eq nil
    end

    it "returns url from DB" do
      SpecHelper.setup
      Crecto::Repo.delete_all(URL)
      create_url(url: "https://yay.com")
      URL.get.should eq "http://yay.cm"
    end
  end

  describe ".set" do
    it "updates the URL" do
      SpecHelper.setup
      Crecto::Repo.delete_all(URL)
      create_url(url: "https://yay.com")
      URL.set("https://asd.com").size.should eq 0
      URL.get.should eq "https://asd.com"
      Crecto::Repo.aggregate(URL, :count, :id).should eq 1
    end

    it "create the URL if not exists" do
      SpecHelper.setup
      Crecto::Repo.delete_all(URL)
      URL.set("https://asd.com").size.should eq 0
      URL.get.should eq "https://asd.com"
      Crecto::Repo.aggregate(URL, :count, :id).should eq 1
    end
  end

end
