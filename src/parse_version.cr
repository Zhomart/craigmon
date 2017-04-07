require "yaml"
puts YAML.parse(File.read "shard.yml")["version"].to_s
