require 'kook'
require 'capybara/rspec'

Capybara.app_host = 'file:///'
Capybara.run_server = false
Capybara.default_wait_time = 15
Capybara.default_driver = :selenium



# https://code.google.com/p/epubcheck/
class EpubCheck

  JavaPath = "drip"
  EpubCheckPath = "~/Downloads/epubcheck-3.0/epubcheck-3.0.jar"

  def self.validate(epub_path)
    cmd = "#{JavaPath} -jar #{EpubCheckPath} #{epub_path}"
    stdout = `#{cmd}`

    return (not stdout.match("No errors or warnings detected.").nil?)
  end

end

RSpec::Matchers.define :be_a_valid_epub do
	match do |path|
		EpubCheck.validate(path) == true
	end
end