module Kook
  module Outline

    def kook_outline(root_elem = self.css('body').first, current_section = Section.new(root_elem))
      ret = [current_section]

      root_elem.elements.each do |elem|
        next if SECTIONING_ROOT_NAMES.include? elem.name

        if HEADER_NAMES.include? elem.name

          # Then elem is just the first heading in an Explicit section
          # and creates no new Implicit section
          if current_section.explicit? and current_section.header_element.nil?
            current_section.associate_header elem
            next
          end

          new_section = Section.new(elem)

          # Head up the section tree until we reach an acceptably high header level (or reach the top of the tree)
          while not current_section.nil? and (current_section.header_rank.nil? or new_section.header_rank <= current_section.header_rank)
            current_section = current_section.parent
          end

          (current_section.nil? ? ret : current_section) << new_section

          current_section = new_section

        elsif SECTION_NAMES.include? elem.name
          self.kook_outline(elem).each {|s| current_section << s}
        else
          self.kook_outline(elem, current_section)
        end
        
      end
        
      return ret
    end

  end
end