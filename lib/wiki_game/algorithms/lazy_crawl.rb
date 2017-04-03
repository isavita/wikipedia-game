# frozen_string_literal: true
require 'wikipedia'
require 'set'

module WikiGame
  module Algorithms
    class LazyCrawl
      def crawl(start_page_title, pulling_step)
        visited_pages = Set.new
        frontier = [start_page_title]
        Enumerator.new do |y|

          until frontier.empty?
            page_links = []
            frontier.each do |page_title|
              plcontinue = '||' # start from the beginning of the links list (https://www.mediawiki.org/wiki/API:Links)
              links = []
              begin
                page = Wikipedia.find(page_title, prop: 'links', pllimit: 'max', plcontinue: plcontinue)
                links += (page.links || [])
                (page.links || []).each do |next_page_link|
                  next if visited_pages.include?(next_page_link)
                  page_links << next_page_link
                  visited_pages.add(next_page_link)
                end
                plcontinue = page.raw_data['continue'] && page.raw_data['continue']['plcontinue']
              end while plcontinue
              y.yield [page_title, links]
            end
            frontier = page_links
          end

        end
      end
    end
  end
end
