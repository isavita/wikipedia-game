# frozen_string_literal: true
require './lib/wiki_game/algorithms/graph_search'

module WikiGame
  module Algorithms
    class BreadthFirstSearch < GraphSearch

      def initialize
        @visited_pages = Set.new
        @pages = []
      end

      def path_between(start_page, end_page)
        return [] unless start_page.is_a?(String) && end_page.is_a?(String)
        return [start_page] if start_page == end_page
        find_path!(start_page, end_page)
      end

      protected

      def find_path!(start_page, target_page)
        @pages.push(start_page)
        @visited_pages.add(start_page)
        path_map = {} # for tracking the path
        until @pages.empty?
          next_pages = []
          @pages.each do |current_page|
            most_promising_links(current_page, target_page).each do |next_page|
              @@logger.info(self.class.name) { "Page #{next_page}" }
              next if @visited_pages.include?(next_page)
              @visited_pages.add(next_page)
              path_map[next_page] = current_page
              next_pages << next_page
              return backtrace_path(path_map, start_page, target_page) if next_page == target_page
            end
          end
          @pages = next_pages
        end
      end

      def backtrace_path(path_map, start_page, target_page)
        path = []
        until target_page == start_page
          path.push(target_page)
          target_page = path_map[target_page]
        end
        path.push(start_page)
        path.reverse
      end
    end
  end
end
