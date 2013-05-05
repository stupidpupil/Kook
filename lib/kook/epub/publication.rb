module Kook
  class Publication

    attr_reader :metadata
    attr_accessor :content_documents, :path_map

    def initialize(metadata = {})
      @metadata = {title:SecureRandom.uuid,language:'en-GB', uid:SecureRandom.uuid}.merge metadata
      @content_documents = []
    end

    def build_directory(path)

      render = Proc.new do |template_path|
        File.write(File.join(path,template_path), Kook.engine_for_template(template_path+".haml").render(binding))
      end

      File.write(File.join(path,'mimetype'), File.read(Kook.path_for_template('mimetype')))

      Dir.mkdir(File.join(path,'META-INF'))
      render.call 'META-INF/container.xml'

      #
      # Content Documents
      #

      content_documents = @content_documents.dup

      uri_map = {}
      content_documents.each do |doc|
        uri_map[doc.source_uri] = doc
      end


      Dir.mkdir(File.join(path,'epub'))

      # This is run first to ensure that any necessary anchors are in place before they're written out
      toc_sections = content_documents.map{|doc| doc.outline}.inject([],:+)

      # Get any image references (adding them to map)
      media_resources = []
      image_uris = content_documents.map {|doc| doc.img_src_uris}.flatten.uniq

      image_uris.each do |uri|
        resource = PublicationResource.new(uri)
        media_resources << resource
        uri_map[uri] = resource
      end

      # Rewrite Content Documents

      content_documents.each {|doc| doc.rewrite_using_uri_map(uri_map)}

      Dir.mkdir(File.join(path,'epub/content'))

      content_documents.each do |doc|
        doc.write(path)
      end

      Dir.mkdir(File.join(path,'epub/media'))

      media_resources.each do |rsrc|
        rsrc.write(path)
      end

      render.call 'epub/content/cover.xhtml'


      # Package file - manifest, spine, etc.

      render.call 'epub/package.opf'

      # Navigation file
      Dir.mkdir(File.join(path,'epub/navigation'))
      render.call 'epub/navigation/nav.xhtml'

    end


  end

end