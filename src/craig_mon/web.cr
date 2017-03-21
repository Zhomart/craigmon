require "kemal"

module CraigMon
  module Web

    def self.run
      patch "/api/url" do |env|
        env.response.content_type = "application/json"
        { name: "Serdar", age: 27 }.to_json
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
