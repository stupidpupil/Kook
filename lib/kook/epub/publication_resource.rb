module Kook

  class PublicationResource

    def to_s
      raise
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
