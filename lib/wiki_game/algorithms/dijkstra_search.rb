# frozen_string_literal: true
require './lib/wiki_game/algorithms/graph_search'
require './lib/wiki_game/analyzers/phrase_analyzer'
require 'fc' # priority queue

module WikiGame
  module Algorithms

    class DijkstraSearch < GraphSearch
      def initialize
        @visited = []
        @unvisited = FastContainers::PriorityQueue.new(:min)
        @shortest_distance = Hash.new(Float::INFINITY)
        @parent = {}
      end

      def path_between(start_page, target_page)
        return [] unless start_page.is_a?(String) && target_page.is_a?(String)
        return [start_page] if start_page == target_page
        return [] unless find_path!(start_page, target_page)
        backtrace_path(@parent, start_page, target_page)
      end

      protected

      def find_path!(start_page, target_page)
        @shortest_distance[start_page] = 0
        @unvisited.push(start_page, @shortest_distance[start_page])
        until @unvisited.empty?
          current_page = @unvisited.pop
          most_promising_links(current_page, target_page).each.with_index(1) do |next_page, weight|
            next if @visited.include?(next_page)
            @visited.push(next_page)
            @unvisited.push(next_page, @shortest_distance[current_page] + weight)
            @shortest_distance[next_page] = weight if @shortest_distance[current_page] + weight < @shortest_distance[next_page]
            @parent[next_page] = current_page
            return true if next_page == target_page
          end
        end
      end
    end

  end
end
