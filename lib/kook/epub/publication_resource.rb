module Kook

  class PublicationResource

    def extension
      raise "?!"
    end

    def epub_id
      raise "What should this be?!"
    end

    def filename
      "#{epub_id}.#{extension}"
    end

    def folder
      "content"
    end

    def path
      "#{folder}/#{filename}"
    end

  end
end
