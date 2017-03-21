require "spec"
require "../src/craig_mon"

module SpecHelper

  def self.root : String
    @@root ||= File.expand_path("../..", __FILE__)
  end
end
