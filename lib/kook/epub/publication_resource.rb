module Kook

  class PublicationResource
    include MediaTypeable

    attr_reader :epub_id, :source_uri

    def initialize(source_uri)
      @source_uri = source_uri
      @epub_id = "PubRes" + SecureRandom.uuid.gsub("-","")
      self.guess_media_type!
    end

    def read
      open_arg = source_uri.scheme == 'file' ? source_uri.path : source_uri.to_s
      open(open_arg).read
    end

    def write(build_path)
      File.write(File.join(build_path,"epub",self.epub_path), self.read)
    end

    def epub_dirname
      "media"
    end

    def epub_basename
      "#{epub_id}#{epub_extname}"
    end

    # Path from within the 'epub' directory
    def epub_path
      File.join(epub_dirname, epub_basename)
    end

  end
end
