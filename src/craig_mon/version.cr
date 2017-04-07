module CraigMon
  VERSION = {{ run("#{__DIR__}/../parse_version.cr").stringify }}
end
