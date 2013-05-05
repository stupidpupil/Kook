module Kook

  class PublicationResource

    attr_reader :epub_id, :source_uri

    def initialize(source_uri)
      @source_uri = source_uri
      @epub_id = "PubRes" + SecureRandom.uuid.gsub("-","")

      open_arg = source_uri.scheme == 'file' ? source_uri.path : source_uri.to_s
      @data = open(open_arg).read
    end

    def to_s
      @data.to_s
    end

    def write(build_path)
      File.write(File.join(build_path,"epub",self.epub_fullpath), self.to_s)
    end

    def extension
      Pathname.new(@source_uri.path).extname
    end

    def media_type
      return "image/png" if extension == ".png"
      return "image/jpeg"
    end

    def epub_basepath
      "media"
    end

    def epub_filename
      "#{epub_id}#{extension}"
    end

    def epub_fullpath
      "#{epub_basepath}/#{epub_filename}"
    end

  end
end
