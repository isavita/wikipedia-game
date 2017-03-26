# frozen_string_literal: true
module WikiGame
  module Algorithms
    class BreadthFirstSearchPageRank < BreadthFirstSearch
      PAGES_LIMIT = 100

      # TODO: Add logic that adds the whole page from the links and looks for similarities in the content
      def most_promising_links(current_page, target_page)
        all_links = super
        page_analizer = WikiGame::DataAnalyzers::ElasticsearchAnalyzer.new
        page_analizer.add_pages(all_links)
        page_analizer.find_similar_pages(target_page, PAGES_LIMIT)
      end
    end
  end
end
