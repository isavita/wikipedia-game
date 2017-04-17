# frozen_string_literal: true
require 'wiki_game/crawlers/page_crawler'

RSpec.describe WikiGame::Crawlers::PageCrawler do
  let(:lazy_crawl_strategy) { WikiGame::Algorithms::LazyCrawl.new }

  describe 'Crawing Wikipedia' do
    xit 'an actual crawler that store every page information in redis' do
      crawler = described_class.new(lazy_crawl_strategy)
      crawler.crawl('USA')
    end
  end
end
