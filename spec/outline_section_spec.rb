require 'spec_helper'

describe Kook::Outline::Section do

	context "when created with an h1 element" do
    elem = Nokogiri::XML("<h1>Header One</h1>").root
    section = Kook::Outline::Section.new(elem)

		it "is implicit" do
      section.implicit?.should be true
		end

    it "has a heading with the text of the element" do
      section.heading.should eql('Header One')
    end

    it "has a header rank of 1" do
      section.header_rank.should eql(1)
    end

    it "prevents another header being associated" do
      elem2 = Nokogiri::XML("<h2>Header Two</h2>").root
      expect{section.associate_header(elem2)}.to raise_error("Section is implicit.")
    end

    it "identifies the h1 element as the relevant element" do
      section.relevant_element.should eql(elem)
    end
	end

  context "when created with an article element" do
    elem = Nokogiri::XML("<article><p>Some article</p></article>").root
    section = Kook::Outline::Section.new(elem)
    
    it "is explicit" do
      section.explicit?.should be true
    end

    it "has a heading of 'Untitled Article'" do
      section.heading.should eql('Untitled Article')
    end

    it "identifies the article element as the relevant element" do
      section.relevant_element.should eql(elem)
    end

  end

  context "when created with an article and associated with a h4 element" do
    elem = Nokogiri::XML("<article><p>Some article</p></article>").root
    section = Kook::Outline::Section.new(elem)

    elem2 = Nokogiri::XML("<h4>Header Four</h4>").root
    section.associate_header(elem2)

    it "has a header rank of 4" do
      section.header_rank.should eql(4)
    end

    it "has a heading with the text of the header element" do
      section.heading.should eql('Header Four')
    end

    it "identifies the article element as the relevant element" do
      section.relevant_element.should eql(elem)
    end

  end

end