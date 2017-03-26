# frozen_string_literal: true
require 'elasticsearch'

module WikiGame
  module DataAnalyzers
    class ElasticsearchAnalyzer
      attr_reader :client

      ENV_CONFIG = { url: 'http://localhost:9200', log: false }
      PAGE_MAPPING = {
        index: 'pages',
        type: 'page',
        body: {
          page: {
            properties: {
              title: { type: 'text' }
            }
          }
        }
      }

      def initialize
        @client = Elasticsearch::Client.new(ENV_CONFIG)
        @client.indices.create(PAGE_MAPPING) unless @client.indices.exists?(index: 'pages')
      end

      def add_page(page_title)
        client.index(index: 'pages', type: 'page', body: { title: page_title }, refresh: true)
      end

      def add_pages(page_titles)
        bulk_add(page_titles)
      end

      def find_similar_page(page_title)
        find_similar_pages(page_title, 1).first
      end

      def find_similar_pages(page_title, limit = 20)
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
        { query: { match: { title: query } } }
      end

      def data_formating(result)
        return [] unless result && result['hits'] && result['hits']['hits']
        result['hits']['hits'].map { |r| r['_source']['title'] if r['_source'] }.compact.uniq
      end

      def bulk_add(page_titles)
        return unless page_titles.any?
        pages = page_titles.map do |title|
          { index: { _index: 'pages', _type: 'page', data: { title: title } } }
        end
        client.bulk(body: pages, refresh: true)
      end
    end
  end
end
