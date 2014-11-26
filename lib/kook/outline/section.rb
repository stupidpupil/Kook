module Kook
  module Outline

    HEADER_NAMES = ['h1','h2','h3','h4','h5','h6']
    SECTION_NAMES = ['section','article', 'aside', 'nav']
    SECTIONING_ROOT_NAMES = ['blockquote','body','details','dialog','fieldset','figure','td']

    class Section

      attr_reader :header_element, :section_element, :children
      attr_accessor :parent

      def initialize(element, parent = nil)
        @section_element = element if (SECTIONING_ROOT_NAMES+SECTION_NAMES).include? element.name
        @header_element = element if HEADER_NAMES.include? element.name
        raise "#{element} is not a valid argument for Kook::Outline::Section" if @section_element.nil? and @header_element.nil?
        
        @children = []
        @parent = parent
        parent << elem unless parent.nil?
      end

      # The element that the user should be 'jumped' to when trying to view this section  
      def relevant_element
        section_element or header_element
      end

      def associate_header(elem)
        raise "Section is implicit." if self.implicit?
        raise "Element is not a header." if not HEADER_NAMES.include? elem.name
        @header_element = elem
      end

      def header_rank
        header_element ? header_element.name[1].to_i : nil
      end

      def heading
        header_element ? header_element.text : "Untitled #{section_element.name.capitalize}"
      end

      def implicit?
        section_element.nil?
      end

      def explicit?
        not implicit?
      end

      def <<(elem)
        @children << elem
        elem.parent = self
      end

    end
  end
end