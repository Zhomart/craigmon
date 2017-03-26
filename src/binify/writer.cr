module Binify
  class Writer

    def self.write_file(dest : String, source : String)
      raise "#{source} is not a file" if !File.file?(source)
      
    end

  end
end
