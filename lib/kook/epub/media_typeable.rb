module Kook
  module MediaTypeable

    def media_type=(media_type)
      @media_type = media_type
    end

    def media_type
      @media_type
    end

    MEDIA_TYPE_TO_EXTENSION = {
      'image/gif' =>  '.gif',
      'image/jpeg' => '.jpg',
      'image/png' =>  '.png',
      'image/svg+xml' => '.svg',
      'application/xhtml+xml' => '.xhtml',
      'text/css' => '.css'
    }

    def epub_extname
      MEDIA_TYPE_TO_EXTENSION[media_type]
    end

    def guess_media_type!
      # Try to guess from the extension
      # Consider using the mime-types gem instead
      extension_to_media_type = MEDIA_TYPE_TO_EXTENSION.invert
      source_extname = Pathname.new(source_uri.path).extname
      if extension_to_media_type.has_key? source_extname
        self.media_type = extension_to_media_type[source_extname]
        return media_type
      end

      # If appropriate, try to guess from the HTTP headers
      if source_uri.scheme == 'http' or source_uri.scheme == 'https'
        http_media_type = nil
        open(source_uri.to_s) {|f| http_media_type = f.content_type}

        if MEDIA_TYPE_TO_EXTENSION.has_key? http_media_type
          self.media_type = http_media_type
          return media_type
        end
      end


      self.media_type = nil
    end

  end
end