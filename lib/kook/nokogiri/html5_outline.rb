module Nokogiri
  module XML
    class Document

      HEADER_NAMES = ['h1','h2','h3','h4','h5','h6']
      SECTION_NAMES = ['section','article', 'aside', 'nav']
      SECTIONING_ROOT_NAMES = ['blockquote','body','details','dialog','fieldset','figure','td']

      def self.html5_outline(root_elem, current_section = {section_elem: root_elem, sections:[], header_level:0, parent:nil, explicit:true})

        ret = [current_section]

        root_elem.elements.each do |elem|
          next if SECTIONING_ROOT_NAMES.include? elem.name

          if HEADER_NAMES.include? elem.name
            header_level = HEADER_NAMES.index(elem.name)+1

            # Then elem is just the first heading in an Explicit section
            # and creates no new Implicit section
            if current_section[:explicit] and current_section[:heading].nil?
              current_section[:heading] = elem.text
              current_section[:header_level] = header_level
              current_section[:heading_elem] = elem
              next
            end

            # Head up the section tree until we reach an acceptably high header level (or reach the top of the tree)
            while not current_section.nil? and header_level <= current_section[:header_level] 
              current_section = current_section[:parent]
            end

            current_section = {heading:elem.text, sections:[], header_level:header_level, parent:current_section, explicit:false, heading_elem:elem}

            if current_section[:parent].nil?
              ret << current_section
            else
              current_section[:parent][:sections] << current_section
            end
            next
          end

          if SECTION_NAMES.include? elem.name
            current_section[:sections] += html5_outline(elem, {section_elem: elem, sections:[], header_level:0, parent:current_section, explicit:true})
            next
          end

          html5_outline(elem, current_section)
        end

        return ret
      end

      def html5_outline
        return self.class.html5_outline(css('body').first)
      end

    end
  end
end