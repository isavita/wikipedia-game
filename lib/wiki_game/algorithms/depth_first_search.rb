# frozen_string_literal: true
module WikiGame
  module Algorithms
    class DepthFirstSearch < GraphSearch

      def initialize
        @visited_pages = Set.new
        @page_stack = []
      end

      def path_between(start_page, end_page)
        find_path!(start_page, end_page)
      end

      protected

      def find_path!(start_page, target_page)
        @page_stack.push(start_page)
        path_map = {} # for tracking the path
        loop do
          current_page = @page_stack.pop
          next if @visited_pages.include?(current_page)
          @visited_pages.add(current_page)
          break if current_page.nil? || current_page == target_page
          @page_stack += most_promising_links(current_page, target_page)
          path_map[@page_stack.last] = current_page
        end

        backtrace_path(path_map, start_page, target_page)
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
