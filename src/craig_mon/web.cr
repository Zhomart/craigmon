require "kemal"

module CraigMon
  module Web

    def self.run
      get "/api/url" do |env|
        env.response.content_type = "application/json"
        url = CraigMon.db.query_one? "SELECT url FROM urls limit 1", as: { String }
        { url: url }.to_json
      end

      patch "/api/url" do |env|
        env.response.content_type = "application/json"
        url = env.params.body["url"].as(String)
        id = CraigMon.db.query_one? "SELECT id FROM urls limit 1", as: { Int32 }
        if id
          CraigMon.db.exec "UPDATE urls SET url=? WHERE id=?", url, id
        else
          CraigMon.db.exec "INSERT INTO urls (id, name, url) VALUES (?, ?, ?)", 1, "default", url
        end

        { result: "ok" }.to_json
      end

      get("/api/*" ) { |env| env.response.status_code = 404 }
      get("/*") { File.read("public/index.html") }
      get("/") { File.read("public/index.html") }

      error 404 do
        "404 - Page not found."
      end

      Kemal.run
    end
  end
end
