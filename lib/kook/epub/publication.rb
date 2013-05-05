module Kook
  class Publication

    attr_reader :metadata
    attr_accessor :content_document_providers

    def initialize(metadata = {})
      @metadata = {title:SecureRandom.uuid,language:'en-GB', uid:SecureRandom.uuid}.merge metadata
      @content_document_providers = []
      @filename_map = {}
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

      content_documents = @content_document_providers.map {|p| ContentDocument.new(p)}

      Dir.mkdir(File.join(path,'epub'))
      Dir.mkdir(File.join(path,'epub/content'))

      # This is run first to ensure that any necessary anchors are in place
      toc_sections = content_documents.map{|doc| doc.outline}.inject([],:+)

      content_documents.each do |doc|
        doc.write(path)
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