require "baked_file_system"

class FileStorage
  BakedFileSystem.load("../../../public", __DIR__)
end
