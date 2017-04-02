# frozen_string_literal: true
require './lib/wiki_game/stores/redis'
require './lib/wiki_game/algorithms/lazy_crawl'

module WikiGame
  module Crawlers
    class PageCrawler
      attr_accessor :crawl_strategy

      def initialize(crawl_strategy)
        @crawl_strategy = crawl_strategy
      end

      def crawl(start_page, pulling_step = 10)
        @crawl_strategy.crawl(start_page, pulling_step).each do |page_title, links|
          next if page.nil? || page.json['missing'] # if the page does not exist
          WikiGame::DataStores::RedisStore.add(page.title, page_data(page_title, links)) rescue next
        end
      end

      private

      def page_data(page_title, links)
        {
          title: page_title,
          links: links
        }
      end
    end
  end
end
