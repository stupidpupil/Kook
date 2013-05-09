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
      super source_uri
      @noko_doc = Nokogiri.XML(xml)
      @noko_doc.extend(Kook::Outline)
    end

    def epub_dirname
      "content"
    end

    #
    #
    #

    def read
      return @noko_doc.to_xml
    end

    def outline
      return @outline unless @outline.nil?

      @outline = @noko_doc.kook_outline
      @outline.each {|s| s.set_href_with_path(epub_path)}

      return @outline
    end

    REFERENCED_RESOURCE_ELEMENT_ATTR_COMBINATIONS = [
      ['img','src'],
      ['link','href'],
      ['object','data'],
      ['embed','src'],
      ['iframe','src'],
      ['video','src'],
      ['audio','src'],
      ['source','src'],
      ['track','src']
    ]

    def referenced_resource_uris
      uris = []
      REFERENCED_RESOURCE_ELEMENT_ATTR_COMBINATIONS.each do |c|
        uris += @noko_doc.css(c[0]).map {|elem| self.source_uri.merge(elem[c[1]])}
      end  
      uris.each {|u| u.fragment = nil}
      return uris
    end

    def rewrite_using_uri_map(uri_map)

      REFERENCED_RESOURCE_ELEMENT_ATTR_COMBINATIONS.each do |c|
        @noko_doc.css(c[0]).each do |elem|
          uri = self.source_uri.merge(elem[c[1]])
          elem[c[1]] = "../"+uri_map[uri].epub_path if uri_map.has_key? uri
        end
      end

      @noko_doc.css('a').each do |a|
        uri = self.source_uri.merge(a['href'])
        fragment = uri.fragment.nil? ? "" : "#" + uri.fragment
        uri.fragment = nil
        a['href'] = "../" + uri_map[uri].epub_path + fragment if uri_map.has_key? uri
      end

    end


  end
end