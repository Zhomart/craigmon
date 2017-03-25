module CraigMon::Models
  class Search < Crecto::Model
    alias Repo = Crecto::Repo

    schema "searches" do
      field :name, String
      field :url, String
      field :active, Bool
      field :crawled_at, Time
    end

    validate_required [:name, :url]
    validate_format :url, /^https?:\/\/.+/

  end
end
