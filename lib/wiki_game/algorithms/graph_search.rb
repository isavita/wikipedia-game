# frozen_string_literal: true
require 'logger'
require 'wikipedia'

module WikiGame
  module Algorithms

    class GraphSearch
      @@logger = Logger.new(STDOUT)#File.new('tmp/graph_searches.log', 'w'), 'daily')

      def path_between(start_page, target_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      protected

      def find_path!(start_page, target_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      def most_promising_links(current_page, target_page)
        page_links = []
        plcontinue = '||' # start from the beginning of the links list
        begin
          page = Wikipedia.find(current_page, prop: 'links', pllimit: 'max', plcontinue: plcontinue)
          page_links += page.links if page.links
          plcontinue = page.raw_data['continue'] && page.raw_data['continue']['plcontinue']
        end while plcontinue
        page_links
      end

      def backtrace_path(parent, start_page, target_page)
        path = []
        until target_page == start_page
          path.push(target_page)
          target_page = parent[target_page]
        end
        path.push(start_page)
        path.reverse
      end
    end

  end
end
