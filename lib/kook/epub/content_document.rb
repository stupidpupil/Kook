module Kook

  class ContentDocument < PublicationResource


    attr_reader :epub_id, :source_uri

    def self.new_with_xml(xml)
      ContentDocument.new(xml, nil)
    end
  
    def initialize(xml, source_uri)
      @noko_doc = Nokogiri.XML(xml)
      @epub_id = SecureRandom.uuid.gsub("-","")
    end

    def extension
      ".xhtml"
    end

    #
    #
    #

    def to_s
      return @noko_doc.to_xml
    end

    def outline
      return @outline unless @outline.nil?

      o = @noko_doc.html5_outline

      anchor_section = Proc.new do |section|
        if not section[:section_elem].nil?
            elem = section[:section_elem]
        elsif not section[:heading_elem].nil?
            elem = section[:heading_elem]
        end

        if elem.name == 'body'
          section[:href] = "#{self.epub_fullpath}"
        else
          elem['id'] = "kook-toc-id-#{SecureRandom.uuid}" if elem['id'].nil?
          section[:href] = "#{self.epub_fullpath}##{elem['id']}"
        end

        section[:sections].each {|ss| anchor_section.call ss}
      end

      o.each {|s| anchor_section.call s}

      @outline = o

      return @outline
    end

    def referenced_images
      ret = []
      @noko_doc.css('img').each do |img|

      end
    end


  end
end