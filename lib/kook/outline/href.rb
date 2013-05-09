module Kook
  module Outline

    class Section

      def set_href_with_path(path)
        self.children.each {|c| c.set_href_with_path(path)}

        return @href = path if self.relevant_element.name == 'body'

        relevant_element['id'] = "kook-section-#{SecureRandom.uuid}" if relevant_element['id'].nil?
        
        return @href = "#{path}##{relevant_element['id']}"
      end

      def href
        @href
      end

    end
  
  end
end