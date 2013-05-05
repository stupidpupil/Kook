require 'kook'

class EpubCheck

  JavaPath = "java"
  EpubCheckPath = "~/Downloads/epubcheck-3.0/epubcheck-3.0.jar"

  def self.validate(epub_path)
    cmd = "#{JavaPath} -jar #{EpubCheckPath} #{epub_path}"
    stdout = `#{cmd}`

    return (not stdout.match("No errors or warnings detected.").nil?)
  end

end