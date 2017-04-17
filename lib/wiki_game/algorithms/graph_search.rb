# frozen_string_literal: true
require './lib/wiki_game/stores/redis'
require 'logger'
require 'wikipedia'

module WikiGame
  module Algorithms

    class GraphSearch
      @@logger = Logger.new(STDOUT)#File.new('tmp/graph_searches.log', 'w'), 'daily')
      @@store = WikiGame::Stores::Redis

      def path_between(start_page, target_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      protected

      def find_path!(start_page, target_page)
        raise NotImplementedError, 'Implement me in the subclass'
      end

      def most_promising_links(current_page, target_page)
        if @@store.exists?(current_page)
          page = @@store.get(current_page)
          [] unless page && page['links']
          page['links']
        else
          links = most_promising_links_wikipedia_api(current_page)
          # Store the missing page in redis
          WikiGame::Stores::Redis.add(current_page, { title: current_page, links: links }) rescue @@logger.error "Redis store could not add page: #{current_page}"
          links
        end
      end

      def most_promising_links_wikipedia_api(current_page)
        page_links = []
        plcontinue = '||' # start from the beginning of the links list
        begin
          page = Wikipedia.find(current_page, prop: 'links', pllimit: 'max', plcontinue: plcontinue)
          page_links += page.links if page.links
          plcontinue = page.raw_data['continue'] && page.raw_data['continue']['plcontinue']
        end while plcontinue
        page_links
      end

      def backtrace_path(parent, start_page, target_page)
        path = []
        until target_page == start_page
          path.push(target_page)
          target_page = parent[target_page]
        end
        path.push(start_page)
        path.reverse
      end
    end

  end
end
