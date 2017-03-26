# frozen_string_literal: true
module WikiGame
  module Algorithms
    class BreadthFirstSearch < GraphSearch

      def initialize
        @visited_pages = Set.new
        @page_queue = Queue.new
      end

      def path_between(start_page, end_page)
        find_path!(start_page, end_page)
      end

      protected

      def find_path!(start_page, target_page)
        @page_queue.enq(start_page)
        @visited_pages.add(start_page)
        path_map = {} # for tracking the path
        until @page_queue.empty?
          current_page = @page_queue.deq
          break if current_page.nil? || current_page == target_page
          most_promising_links(current_page, target_page).each do |next_page|
            next if @visited_pages.include?(next_page)
            @visited_pages.add(next_page)
            path_map[next_page] = current_page
            @page_queue.enq(next_page)
          end
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
