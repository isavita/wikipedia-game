# frozen_string_literal: true
require 'elasticsearch'
require 'wikipedia'

module WikiGame
  module DataAnalyzers
    class ElasticsearchAnalyzer
      attr_reader :client

      ENV_CONFIG = { host: 'localhost:9200', log: false }
      PAGE_MAPPING = {
        index: 'pages',
        type: 'page'
      }

      def initialize
        @client = Elasticsearch::Client.new(ENV_CONFIG)
        @client.indices.create(PAGE_MAPPING) unless @client.indices.exists?(index: 'pages')
      end

      def add_page(page_title)
        client.index(index: 'pages', type: 'page', body: page_data(page_title), refresh: true)
      end

      def add_pages(page_titles)
        bulk_add(page_titles)
      end

      def find_similar_page(page_title)
        find_similar_pages(page_title, 1).first
      end

      def find_similar_pages(page_title, limit = 10)
        search(page_title, limit)
      end

      def delete_index(index = 'pages')
        client.indices.delete(index: index) if @client.indices.exists?(index: index)
      end

      private

      def search(query, limit = nil)
        result = client.search(index: 'pages', body: search_query(query), size: limit)
        data_formating(result)
      end

      def search_query(query)
        { query: { multi_match: { query: query, fields: %w(title body) } } }
      end

      def data_formating(result)
        return [] unless result && result['hits'] && result['hits']['hits']
        result['hits']['hits'].map { |r| r['_source']['title'] if r['_source'] }.compact.uniq
      end

      def bulk_add(page_titles)
        return unless page_titles.any?
        pages = page_titles.map do |page_title|
          { index: { _index: 'pages', _type: 'page', data: page_data(page_title) } }
        end
        client.bulk(body: pages, refresh: true)
      end

      def page_data(page_title)
        page = Wikipedia::find(page_title)
        { title: page.title, body: page.text }
      end
    end
  end
end
