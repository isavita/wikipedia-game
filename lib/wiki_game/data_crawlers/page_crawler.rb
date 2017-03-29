# frozen_string_literal: true
require 'wiki_game/data_stores/redis_store'

module WikiGame
  module DataCrawlers
    class PageCrawler
      attr_accessor :crawl_strategy

      def initialize(crawl_strategy)
        @crawl_strategy = crawl_strategy
      end

      def crawl(start_page, end_page = 'Crawl Every Page in Wikipedia', pulling_step = 100)
        @crawl_strategy.crawl(start_page, end_page, pulling_step)
      end
    end
  end
end
