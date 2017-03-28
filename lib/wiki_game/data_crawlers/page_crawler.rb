# frozen_string_literal: true
require './lib/wiki_game/data_stores/redis_store'
require './lib/wiki_game/algorithms/lazy_crawl'

module WikiGame
  module DataCrawlers
    class PageCrawler
      attr_accessor :crawl_strategy

      def initialize(crawl_strategy)
        @crawl_strategy = crawl_strategy
      end

      def crawl(start_page, pulling_step = 10)
        @crawl_strategy.crawl(start_page, pulling_step).each do |page|
          next if page.nil? || page.json['missing']
          WikiGame::DataStores::RedisStore.add(page.title, page_data(page))
        end
      end

      private

      def page_data(page)
        {
          title: page.title,
          summary: page.summary,
          text: page.text,
          fullurl: page.fullurl
        }
      end
    end
  end
end
