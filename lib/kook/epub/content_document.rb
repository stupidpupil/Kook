module Kook

  # ContentDocument is a wrapper for an object that responds to one of PROVIDE_METHODS
  # It generates an #outline (for the Table of Contents) and extracts any images from the XHTML provided.

  class ContentDocument < PublicationResource

    PROVIDE_METHODS = [:to_xhtml, :read, :to_s]

    attr_reader :index
  
    def initialize(provider, index)
      @index = index

      xml = nil

      PROVIDE_METHODS.each do |m|
        xml = provider.send(m) if provider.respond_to? m
        break if not xml.nil?
      end

      raise "#{provider} responded to none of #{PROVIDE_METHODS.inspect}" if xml.nil?

      @noko_doc = Nokogiri.XML(xml)

    end

    def extension
      ".xhtml"
    end

    def epub_id
      "content_#{index}"
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


  end
end