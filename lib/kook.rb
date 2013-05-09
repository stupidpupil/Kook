require 'securerandom'

require 'haml'
require 'nokogiri'

require 'pathname'
require 'uri'
require 'open-uri'

require 'zip/zip'

module Kook
	DEFAULT_TEMPLATES_DIR = File.expand_path("../../templates/", __FILE__)

	def self.path_for_template(tpath)
		File.expand_path(tpath,DEFAULT_TEMPLATES_DIR)
	end

	def self.engine_for_template(tpath)
		Haml::Engine.new(File.read(Kook.path_for_template(tpath)))
	end

end

require 'kook/outline/section'
require 'kook/outline/outline'
require 'kook/outline/href'

require 'kook/epub/publication'

require 'kook/epub/media_typeable'
require 'kook/epub/publication_resource'

require 'kook/epub/content_document'


