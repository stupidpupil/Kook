module Kook

  class PublicationResource

    attr_reader :epub_id

    def to_s
      raise 'No to_s defined!'
    end

    def write(build_path)
      File.write(File.join(build_path,"epub",self.epub_fullpath), self.to_s)
    end

    def extension
      raise 'No extension defined!'
    end

    def epub_filename
      "#{epub_id}.#{extension}"
    end

    def epub_basepath
      "content"
    end

    def epub_fullpath
      "#{epub_basepath}/#{epub_filename}"
    end

  end
end
