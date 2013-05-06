require 'spec_helper'

describe Kook::Publication do
  context "when given no content documents" do
    k = Kook::Publication.new({title:'An EPUB Publication'})

    it "should produce a valid EPUB Publication" do
      d = Dir.mktmpdir
      p = File.join(d,'temporary.epub')
      k.build_epub(p)
      EpubCheck.validate(p).should be_true
    end
    
  end


end