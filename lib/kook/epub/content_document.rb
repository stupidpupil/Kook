module Kook

  class ContentDocument < PublicationResource

    def self.new_with_xml(xml)
      ContentDocument.new(xml, URI.parse(''))
    end

    def self.new_with_path(path)
      xml = File.read(path)
      source_uri = URI.parse("file://"+Pathname.new(path).realpath.to_s)
      ContentDocument.new(xml, source_uri)
    end

    def self.new_with_uri(uri)
      xml = open(uri).read
      source_uri = URI.parse(uri)
      ContentDocument.new(xml, source_uri)
    end
  
    def initialize(xml, source_uri)
      @source_uri = source_uri
      @epub_id = "ContDoc"+SecureRandom.uuid.gsub("-","")
      @noko_doc = Nokogiri.XML(xml)
    end

    def epub_basepath
      "content"
    end


    def extension
      '.xhtml'
    end

    def media_type
      'application/xhtml+xml'
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

    def img_src_uris
      uris = @noko_doc.css('img').map {|img| self.source_uri.merge(img['src'])}
      uris.each {|u| u.fragment = nil}
      return uris
    end

    def rewrite_using_uri_map(uri_map)
      @noko_doc.css('img').each do |img|
        uri = self.source_uri.merge(img['src'])
        img['src'] = "../"+uri_map[uri].epub_fullpath if uri_map.has_key? uri
      end
    end


  end
end