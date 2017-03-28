# frozen_string_literal: true
require 'wiki_game/data_crawlers/page_crawler'

RSpec.describe WikiGame::DataCrawlers::PageCrawler do
  let(:lazy_crawl_strategy) { WikiGame::Algorithms::LazyCrawl.new }

  describe 'Crawing Wikipedia' do
    it 'an actual crawler that store every page information in redis' do
      crawler = described_class.new(lazy_crawl_strategy)
      crawler.crawl('Benjamin+Franklin')
    end
  end
end
