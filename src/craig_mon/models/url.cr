module CraigMon::Models
  class URL < Crecto::Model
    alias Repo = Crecto::Repo

    schema "urls" do
      field :name, String
      field :url, String
    end

    validate_required [:name, :url]
    validate_format :url, /^https?:\/\/.+/

    def self.get : String | Nil
      urls = Repo.all(self)
      return nil if urls.size == 0
      urls.first.url
    end

    def self.set(url : String) : Array(String)
      if Repo.aggregate(self, :count, :id) == 0
        _url = URL.new
        _url.name = "default"
        _url.url = url
        Repo.insert(_url)
      else
        _url = Repo.all(self).first
        _url.url = url
        Repo.update(_url)
      end.errors.map { |h| "#{h[:field]} #{h[:message]}" }
    end

  end
end
