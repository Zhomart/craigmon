require "./binify/*"

module Binify

  SEPARATOR_S = "FF AA 54 23 00 7B 00 B5 C3 45 92 74 F3 01 AA FF"
  SEPARATOR = Slice(UInt8).new(SEPARATOR_S.split(" ").map(&.to_u8(16)).to_unsafe, 16)

  # make sure SEPARATOR doesn't exist
  def self.validate_sep!(bytes : Slice(UInt8))
    (bytes.size - 16).times do |pos|
      _bytes = bytes[pos, 16]
      if SEPARATOR == _bytes
        raise "Separator #{bytes_to_s(SEPARATOR).inspect} found in file."
      end
    end
  end

  def self.load_dest_file(dest : String) : Slice(UInt8)
    raise "#{dest} is not a file" if !File.file?(dest)
    bytes = Slice(UInt8).new(0)
    File.open(dest, "rb") do |file|
      bytes = Slice(UInt8).new(file.size)
      file.read(bytes)
    end
    bytes
  end

  def self.bytes_to_s(bytes : Slice(UInt8)) : String
    res = String::Builder.new
    bytes.each_with_index do |by, i|
      res << " " if i > 0 && i % 4 == 0
      q = by.to_s(16).upcase
      res << "0" if q.size == 1
      res << q
    end
    res.to_s
  end

  def self.run
    dest_bytes = load_dest_file("./craigmon")
    validate_sep!(dest_bytes)

    Writer.append_text("./craigmon", "name", "hello world")
    # Reader.read_text("./craigmon")
  end
end

Binify.run
