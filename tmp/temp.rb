Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each {|file| require file }
store = WikiGame::DataStores::RedisStore
crawler = WikiGame::DataCrawlers::PageCrawler.new(WikiGame::Algorithms::LazyCrawl.new)
crawler.crawl('London')
