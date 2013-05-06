require 'spec_helper'

describe Kook::Publication do
  it "should produce a valid EPUB Publication" do
    k = Kook::Publication.new({title:'An EPUB Publication'})
    d = Dir.mktmpdir
    p = File.join(d,'temporary.epub')
    k.build_epub(p)
    EpubCheck.validate(p).should be_true
  end


end