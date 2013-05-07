require 'spec_helper'

describe Kook::Publication do
  context "when given no content documents" do
    k = Kook::Publication.new({title:'An EPUB Publication'})

    it "should produce a valid EPUB Publication" do
      d = Dir.mktmpdir
      p = File.join(d,'temporary.epub')
      k.build_epub(p)
      p.should be_a_valid_epub
    end
    
  end

  context "when given a single content document" do
    k = Kook::Publication.new({title:'An EPUB Publication'})
    k.content_documents << Kook::ContentDocument.new_with_path(File.expand_path('publication_spec_examples/simple/simple.xhtml', File.dirname(__FILE__)))

    it "should produce a valid EPUB Publication" do
      d = Dir.mktmpdir
      p = File.join(d,'temporary.epub')
      k.build_epub(p)
      p.should be_a_valid_epub
    end
  end

  context "when given a set of hyperlinked content documents" do
    k = Kook::Publication.new({title:'An EPUB Publication'})
    k.content_documents << Kook::ContentDocument.new_with_path(File.expand_path('publication_spec_examples/complex/0.xhtml', File.dirname(__FILE__)))
    k.content_documents << Kook::ContentDocument.new_with_path(File.expand_path('publication_spec_examples/complex/1.xhtml', File.dirname(__FILE__)))

    it "should produce a valid EPUB Publication" do
      d = Dir.mktmpdir
      p = File.join(d,'temporary.epub')
      k.build_epub(p)
      p.should be_a_valid_epub
    end
  end


end