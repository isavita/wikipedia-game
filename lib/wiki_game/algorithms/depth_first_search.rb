# frozen_string_literal: true
require './lib/wiki_game/algorithms/graph_search'

module WikiGame
  module Algorithms

    class DepthFirstSearch < GraphSearch
      def initialize
        @parent = {}
      end

      def path_between(start_page, target_page)
        return [] unless start_page.is_a?(String) && target_page.is_a?(String)
        return [start_page] if start_page == target_page
        return [] unless find_path!(start_page, target_page)
        backtrace_path(@parent, start_page, target_page)
      end

      protected

      def find_path!(start_page, target_page)
        most_promising_links(start_page, target_page).each do |page|
          if @parent[page].nil?
            @parent[page] = start_page
            return page if page == target_page
            return page if find_path!(page, target_page) == target_page
          end
        end
      end
    end

  end
end
