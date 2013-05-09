require 'spec_helper'

describe Kook::Publication, :type => :feature do
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

    it "should ensure that the Table of Contents works" do
      d = Dir.mktmpdir
      k.build_directory(d)

      visit File.join(d,'epub','navigation','nav.xhtml')
      page.find(:xpath, "//*[text()='Chapter 1'][name()='a']").click
      page.find(:xpath, "//*[text()='Chapter 1'][name()='h1']").should_not be_nil

    end

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

    it "should ensure that the hyperlinks work" do
      d = Dir.mktmpdir
      k.build_directory(d)

      visit File.join(d,'epub','navigation','nav.xhtml')
      page.find(:xpath, "//*[text()='Prologue'][name()='a']").click

      page.find(:xpath, "//*[text()='Prologue'][name()='h1']").should_not be_nil
      page.find(:xpath, "//*[text()='But a link to the first chapter!'][name()='a']").click

      page.find(:xpath, "//*[text()='Chapter 1'][name()='h1']").should_not be_nil
    end


    it "should produce a valid EPUB Publication" do
      d = Dir.mktmpdir
      p = File.join(d,'temporary.epub')
      k.build_epub(p)
      p.should be_a_valid_epub
    end
  end


end