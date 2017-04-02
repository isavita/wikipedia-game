# frozen_string_literal: true
require 'wiki_game/stores/redis'

RSpec.describe WikiGame::Stores::Redis do
  let(:page) { { 'title' => 'Fake London', 'fullurl' => 'https://en.wikipedia.org/wiki/London' } }
  let(:page_with_links) { page.merge('links' => ['Paris', '10 Downing Street']) }

  before(:each) do
    test_config = {
      host: '127.0.0.1',
      port: 6379,
      namespace: 'test',
      db: 1
    }
    stub_const('WikiGame::Stores::Redis::ENV_CONFIG', test_config)
    described_class.reconnect
    described_class.flushdb
    expect(described_class.client.DBSIZE).to be_zero
  end

  context '.add and .get' do
    it 'can add nil value and store it as boolean true' do
      expect(described_class.add('key', nil)).to be_truthy
      expect(described_class.get('key')).to eq(true)
    end

    it 'can add empty string and store it as boolean true' do
      expect(described_class.add('key', '')).to be_truthy
      expect(described_class.get('key')).to eq(true)
    end

    it 'get nil when key does not exist' do
      expect(described_class.get('key')).to be_nil
    end

    it 'get true when key is nil' do
      expect(described_class.add(nil, 'value')).to be_truthy
      expect(described_class.get(nil)).to eq(true)
    end

    it 'can add/get a new hash' do
      expect(described_class.get(page['title'])).to be_nil
      expect(described_class.add(page['title'], page)).to be_truthy
      expect(described_class.get(page['title'])).to eq(page)
    end

    it 'can add/get a new hash when the keys are symbols' do
      page_with_symbol_keys = { title: 'Fake London', fullurl: 'https://en.wikipedia.org/wiki/London' }
      expect(described_class.get(page_with_symbol_keys[:title])).to be_nil
      expect(described_class.add(page_with_symbol_keys[:title], page)).to be_truthy
      expect(described_class.get(page_with_symbol_keys[:title])).to eq(page)
    end

    it 'add overwrite existing hash' do
      expect(described_class.add(page['title'], page)).to be_truthy
      expect(described_class.get(page['title'])).to eq(page)
      extended_page = page.merge('subtitle' => 'Greater London Authority')
      expect(described_class.add(page['title'], extended_page)).to be_truthy
      expect(described_class.get(page['title'])).to eq(extended_page)
    end

    it 'can add/get a hash which contains an associative array' do
      expect(described_class.get(page_with_links['title'])).to be_nil
      expect(described_class.add(page_with_links['title'], page_with_links)).to be_truthy
      expect(described_class.get(page_with_links['title'])).to eq(page_with_links)
      expect(described_class.get(page_with_links['title'])['links']).to match_array(page_with_links['links'])
    end
  end

  context '.delete' do
    it 'can remove element for the store' do
      expect(described_class.get(page['title'])).to be_nil
      expect(described_class.add(page['title'], page)).to be_truthy
      expect(described_class.delete(page['title'])).to be_truthy
      expect(described_class.get(page['title'])).to be_nil
    end
  end

  context '.exists?' do
    it 'can remove element for the store' do
      expect(described_class.get(page['title'])).to be_nil
      expect(described_class.add(page['title'], page)).to be_truthy
      expect(described_class.exists?(page['title'])).to be_truthy
    end
  end
end
