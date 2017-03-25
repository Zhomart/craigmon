require "kemal"
require "json"

module CraigMon
  module Web

    alias Repo = Crecto::Repo
    alias Q = Crecto::Repo::Query
    alias Search = Models::Search
    alias Item = Models::Item

    def self.run
      get "/api/searches" do |env|
        env.response.content_type = "application/json"
        { searches: searches() }.to_json
      end

      post "/api/searches" do |env|
        env.response.content_type = "application/json"
        name = env.params.body["name"].as(String)
        url = env.params.body["url"].as(String)
        search = Search.new
        search.name = name
        search.url = url
        search.active = true
        errors = Repo.insert(search).errors
        if errors.empty?
          { searches: searches() }.to_json
        else
          env.response.status_code = 400
          { errors: errors }.to_json
        end
      end

      patch "/api/searches/:id" do |env|
        env.response.content_type = "application/json"
        search = Repo.get(Search, env.params.url["id"]).as(Search)
        search.active = !!env.params.json["active"] if env.params.json.has_key?("active")
        search.name = env.params.json["name"].to_s if env.params.json.has_key?("name")
        search.url = env.params.json["url"].to_s if env.params.json.has_key?("url")
        searchChange = Repo.update(search)
        if searchChange.errors.empty?
          { search: searchChange.instance }.to_json
        else
          env.response.status_code = 400
          message = searchChange.errors.map { |e| "#{e[:field]} #{e[:message]}" }
          { errors: searchChange.errors, message: message }.to_json
        end
      end

      get "/api/searches/:search_id/items" do |env|
        env.response.content_type = "application/json"
        search = Repo.get(Search, env.params.url["search_id"]).as(Search)
        per_page = 20
        total = Models::Item.total_count
        pages = (total + per_page - 1) / per_page
        page = env.params.query["page"]?
        page = page ? page.to_i32 : 1
        items = Models::Item.all_for(search.id, limit: per_page, offset: (page-1)*per_page)
        { pages: pages, items: items, search: search }.to_json
      end

      get("/api/*" ) { |env| env.response.status_code = 404 }
      get("/*") { File.read("public/index.html") }
      get("/") { File.read("public/index.html") }

      error 404 do
        "404 - Page not found."
      end

      Kemal.run
    end

    def self.searches
      Repo.all(Search, Q.order_by("created_at DESC"))
    end

  end
end
