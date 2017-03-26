# frozen_string_literal: true
require 'wikipedia'

module WikiGame
  module Algorithms
    class GraphSearch
      def path_between(start_page, end_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      protected

      def find_path!(page_title)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      def most_promising_links(current_page, target_page)
        page_links = []
        plcontinue = '||' # start from the beginning of the links list
        begin
          page = Wikipedia::find(current_page, prop: 'links', pllimit: 'max', plcontinue: plcontinue)
          page_links += page.links if page.links
          plcontinue = page.raw_data['continue'] && page.raw_data['continue']['plcontinue']
        end while plcontinue
        page_links
      end
    end
  end
end
