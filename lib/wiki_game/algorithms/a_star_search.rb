# frozen_string_literal: true
require './lib/wiki_game/algorithms/graph_search'

module WikiGame
  module Algorithms

    class AStarSearch

      def path_between(start_page, target_page)
        return [] unless start_page.is_a?(String) && target_page.is_a?(String)
        return [start_page] if start_page == target_page
        find_path!(start_page)
      end

      protected

      def find_path!(start_page, target_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end
    end

  end
end
