# frozen_string_literal: true
require 'wikipedia'

module WikiGame
  class Engine
    attr_accessor :search_strategy
    attr_reader :start_page_title, :end_page_title

    TIMEOUT_SECONDS = 120

    def initialize(start_page_title, end_page_title, search_strategy)
      @start_page_title = start_page_title
      @end_page_title = end_page_title
      @search_strategy = search_strategy
    end

    def connection_between_pages
      Timeout::timeout(TIMEOUT_SECONDS) do
        page_titles = search_strategy.path_between(start_page_title, end_page_title)
        page_titles.map { |page_title| page_data(page_title) }
      end
    end

    private

    def page_data(page_title)
      page = Wikipedia.find(page_title, prop: 'info')
      {
        title: page.title,
        url: page.fullurl,
      }
    end
  end
end
