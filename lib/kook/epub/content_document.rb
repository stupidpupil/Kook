module Kook
  class ContentDocument

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

    def to_s
      return @noko_doc.to_xml
    end

    def epub_id
      "content_#{index}"
    end

    def filename
      "#{epub_id}.xhtml"
    end

    def path
      "content/#{filename}"
    end

    def outline
      return @outline unless @outline.nil?

      o = @noko_doc.html5_outline

      anchor_section = Proc.new do |section|
        if not section[:heading_elem].nil?
            elem = section[:heading_elem]
        elsif not section[:section_elem].nil?
            elem = section[:section_elem]
        end

        anchor_elem = elem.add_previous_sibling "<a id='kook-toc-anchor-#{SecureRandom.uuid}' class='kook-toc-anchor' />"

        section[:anchor_elem] = anchor_elem
        section[:path] = self.path
        section[:href] = "#{self.path}##{anchor_elem.attr('id')}"

        section[:sections].each {|ss| anchor_section.call ss}
      end

      o.each {|s| anchor_section.call s}

      @outline = o

      return @outline
    end


  end
end