class ServeBakedStatic < Kemal::Handler
  only ["/js/", "/css/"]

  def initialize
    @fallthrough = false
  end

  def call(context)
    return call_next(context) if context.request.path.not_nil! == "/"

    unless context.request.method == "GET" || context.request.method == "HEAD"
      if @fallthrough
        call_next(context)
      else
        context.response.status_code = 405
        context.response.headers.add("Allow", "GET, HEAD")
      end
      return
    end

    original_path = context.request.path.not_nil!
    request_path = URI.unescape(original_path)

    # File path cannot contains '\0' (NUL) because all filesystem I know
    # don't accept '\0' character as file name.
    if request_path.includes? '\0'
      context.response.status_code = 400
      return
    end

    expanded_path = File.expand_path(request_path, "/")

    send_baked_file(context, expanded_path)
  rescue e : BakedFileSystem::NoSuchFileError
    call_next(context)
  end

  # Send a file with given path and base the mime-type on the file extension
  # or default `application/octet-stream` mime_type.
  #
  #   send_file env, "./path/to/file"
  #
  # Optionally you can override the mime_type
  #
  #   send_file env, "./path/to/file", "image/jpeg"
  private def send_baked_file(env, path : String, mime_type : String? = nil)
    mime_type ||= Kemal::Utils.mime_type(path)
    env.response.content_type = mime_type
    file = FileStorage.get(path)
    env.response.content_length = file.size
    file.write_to_io(env.response, false)
  end

end
