require "kemal"

module CraigMon
  module Web

    def self.run
      get "/api/url" do |env|
        env.response.content_type = "application/json"
        { url: Models::URL.get }.to_json
      end

      patch "/api/url" do |env|
        env.response.content_type = "application/json"
        url = env.params.body["url"].as(String)
        Models::URL.update(url)
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
