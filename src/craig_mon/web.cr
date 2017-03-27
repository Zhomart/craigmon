require "kemal"
require "json"
require "kemal-basic-auth"
require "./web/*"

module CraigMon
  module Web

    BAKED = false

    alias Repo = Crecto::Repo
    alias Q = Crecto::Repo::Query
    alias Search = Models::Search
    alias Item = Models::Item

    if BAKED
      serve_static !BAKED
      Kemal.config.add_filter_handler ServeBakedStatic.new
    end

    def self.run
      username, password = nil, nil

      OptionParser.parse! do |parser|
        parser.banner = "Usage: craigmon worker [arguments]"
        parser.on("-u USER", "--user USER", "basic auth username") { |v| username = v }
        parser.on("-p PASSWD", "--password PASSWD", "basic auth password") { |v| password = v }
        parser.on("-h", "--help", "Show this help") {
          puts parser
          exit 0
        }
      end

      if username.is_a?(String) && password.is_a?(String)
        puts "Setting up basic auth, username=#{username}, password=***"
        basic_auth username.as(String), password.as(String)
      end

      get "/api/searches" do |env|
        env.response.content_type = "application/json"
        { searches: all_searches() }.to_json
      end

      post "/api/searches" do |env|
        env.response.content_type = "application/json"
        search = Search.new
        search.name = env.params.json["name"].to_s if env.params.json.has_key?("name")
        search.url = env.params.json["url"].to_s if env.params.json.has_key?("url")
        search.active = true
        errors = Repo.insert(search).errors
        if errors.empty?
          { searches: all_searches() }.to_json
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
        total = Models::Item.total_count(Q.where(search_id: search.id))
        pages = (total + per_page - 1) / per_page
        page = env.params.query["page"]?
        page = page ? page.to_i32 : 1
        items = Models::Item.all_for(search.id, limit: per_page, offset: (page-1)*per_page)
        { pages: pages, items: items, search: search }.to_json
      end

      get "/api/searches/:search_id/items/:id" do |env|
        env.response.content_type = "application/json"
        item = Repo.get(Item, env.params.url["id"]).as(Item)
        { item: item }.to_json
      end

      get("/api/*" ) { |env| env.response.status_code = 404 }
      get("/*") { |env| send_index(env) }
      get("/") { |env| send_index(env) }

      error 404 do
        "404 - Page not found."
      end

      Kemal.run
    end

    def self.send_index(env)
      env.response.content_type = "text/html"
      BAKED ? FileStorage.get("/index.html").read : File.read("public/index.html")
    end

    def self.all_searches
      Repo.all(Search, Q.order_by("created_at DESC"))
    end

  end
end

class Kemal::CommonLogHandler < Kemal::BaseLogHandler

  IGNORE_EXTS = {".tag", ".js", ".css", ".png", ".jpg", ".html", ".ico"}

  def call(context)
    time = Time.now
    call_next(context)
    if IGNORE_EXTS.none? { |ext| context.request.resource.ends_with?(ext) }
      elapsed_text = elapsed_text(Time.now - time)
      @handler << time << " " << context.response.status_code << " " << context.request.method << " " << context.request.resource << " " << elapsed_text << "\n"
    end
    context
  end

end
