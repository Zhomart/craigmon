module CraigMon::Models
  class URL < Crecto::Model
    schema "urls" do
      field :name, String
      field :url, String
    end

    validate_required [:name, :url]
    validate_format :url, /^https?:\/\/.+/

    def self.get : String | Nil
      urls = Crecto::Repo.all(self)
      return nil if urls.size == 0
      urls.first.url
    end

    def self.set(url : String) : Array
      if Crecto::Repo.aggregate(self, :count, :id) == 0
        _url = URL.new
        _url.name = "default"
        _url.url = url
        Crecto::Repo.insert(_url).errors
      else
        _url = Crecto::Repo.all(self).first
        _url.url = url
        Crecto::Repo.update(_url).errors
      end
    end

  end
end
