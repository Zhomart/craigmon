def build_item(&block : CraigMon::Models::Item -> _)
  item = CraigMon::Models::Item.new
  item.uid = 10_000_000_000 + rand(100_000).to_i64
  item.title = Faker::Lorem.sentence
  item.link = Faker::Internet.url("craigslist.com")
  item.date = Time.utc_now - Time::Span.new(rand(10), 0, 0, 0)
  item.issued = Time.utc_now - Time::Span.new(rand(10), 0, 0, 0)
  yield item
  item
end

def build_item
  build_item {}
end

def build_search(&block : CraigMon::Models::Search -> _)
  s = CraigMon::Models::Search.new
  s.name = Faker::Name.title
  s.url = Faker::Internet.url("craigslist.com")
  s.active = true
  yield s
  s
end

def build_search
  build_search {}
end

def create_item(&block : CraigMon::Models::Item -> _)
  item = build_item(&block)
  Crecto::Repo.insert(item).instance
end

def create_search(&block : CraigMon::Models::Search -> _)
  search = build_search(&block)
  Crecto::Repo.insert(search).instance
end

def create_search
  create_search {}
end
