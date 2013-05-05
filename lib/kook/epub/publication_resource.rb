module Kook

  class PublicationResource

    def to_s
      raise
    end

    def write(build_path)
      File.write(File.join(build_path,"epub",self.epub_fullpath), self.to_s)
    end

    def extension
      raise "?!"
    end

    def epub_id
      raise "What should this be?!"
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
