require 'securerandom'
require 'haml'
require 'nokogiri'

module Kook
	DEFAULT_TEMPLATES_DIR = File.expand_path("../../templates/", __FILE__)

	def self.path_for_template(tpath)
		File.expand_path(tpath,DEFAULT_TEMPLATES_DIR)
	end

	def self.engine_for_template(tpath)
		Haml::Engine.new(File.read(Kook.path_for_template(tpath)))
	end

end

require 'kook/nokogiri/html5_outline'
require 'kook/epub/publication'
require 'kook/epub/content_document'


