module Kook
  class Publication

    attr_reader :metadata
    attr_accessor :content_documents

    def initialize(metadata = {})
      @metadata = {title:SecureRandom.uuid,language:'en-GB', uid:SecureRandom.uuid}.merge metadata
      
      @content_documents = []
    end

    def toc_sections
      content_documents.map{|doc| doc.outline}.inject([],:+)
    end

    def referenced_resources
      uris = content_documents.map {|doc| doc.referenced_resource_uris}.flatten.uniq
      uris.delete_if {|uri| uri.scheme == 'kook'}
      uris.map { |uri| PublicationResource.new(uri)}
    end

    def build_directory(path)

      render = Proc.new do |template_path|
        File.write(File.join(path,template_path), Kook.engine_for_template(template_path+".haml").render(binding))
      end

      File.write(File.join(path,'mimetype'), File.read(Kook.path_for_template('mimetype')))

      Dir.mkdir(File.join(path,'META-INF'))
      render.call 'META-INF/container.xml'

      uri_map = {}
      media_resources = referenced_resources

      (content_documents+media_resources).each do |doc|
        uri_map[doc.source_uri] = doc
        uri_map[URI("kook://#{doc.epub_id}")] = doc
      end

      Dir.mkdir(File.join(path,'epub'))

      # Navigation file
      Dir.mkdir(File.join(path, 'epub', 'navigation'))
      render.call 'epub/navigation/nav.xhtml'

      # Rewrite Content Documents

      #content_documents.each {|doc| doc.rewrite_using_uri_map(uri_map)}

      Dir.mkdir(File.join(path,'epub', 'content'))
      render.call 'epub/content/cover.xhtml'

      content_documents.each do |doc|
        doc.write_with_uri_map(path, uri_map)
      end

      Dir.mkdir(File.join(path,'epub', 'media')) if media_resources.any?

      media_resources.each do |rsrc|
        rsrc.write(path)
      end


      # Package file - manifest, spine, etc.

      render.call 'epub/package.opf'



    end

    def build_epub(path)
      tempdir = Dir.mktmpdir
      self.build_directory(tempdir)

      # This messing about is required to ensure that the mimetype entry isn't compressed at all.
      Zip::OutputStream.open(path) do |zip|
        entry = Zip::Entry.new("", 'mimetype')
        entry.gather_fileinfo_from_srcpath File.join(tempdir,'mimetype')
        zip.put_next_entry(entry, nil, nil, Zip::Entry::STORED)
        entry.get_input_stream { |is| Zip::IOExtras.copy_stream(zip, is) }
      end

      Zip::File.open(path, Zip::File::CREATE) do |zipfile|

        Dir[File.join(tempdir,"META-INF", '**', '**')].each do |file|
          zipfile.add(file.sub(tempdir+"/",''), file)
        end

        Dir[File.join(tempdir,"epub", '**', '**')].each do |file|
          zipfile.add(file.sub(tempdir+"/",''), file)
        end

      end

      FileUtils.remove_entry_secure tempdir
    end
  end

end