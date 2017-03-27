# frozen_string_literal: true
require 'wiki_game/engine'
require 'wiki_game/algorithms/graph_search'
require 'wiki_game/algorithms/breadth_first_search'
require 'wiki_game/algorithms/breadth_first_search_page_rank'
require 'wiki_game/algorithms/depth_first_search'

RSpec.describe WikiGame::Engine do
  let(:dfs_strategy) { WikiGame::Algorithms::DepthFirstSearch.new }
  let(:bfs_strategy) { WikiGame::Algorithms::BreadthFirstSearch.new }
  let(:bfs_page_rank_strategy) { WikiGame::Algorithms::BreadthFirstSearchPageRank.new }

  describe '#connection_between_pages' do
    let(:from_bfs_to_algorithm) do
      [
        { title: 'Breadth-first search', url: 'https://en.wikipedia.org/wiki/Breadth-first_search' },
        { title: 'Algorithm', url: 'https://en.wikipedia.org/wiki/Algorithm' }
      ]
    end

    let(:from_a_star_to_allen_newell) do
      [
        { title: 'A* search algorithm', url: 'https://en.wikipedia.org/wiki/A*_search_algorithm' },
        { title: 'Alpha–beta pruning', url: 'https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning' },
        { title: 'Allen Newell', url: 'https://en.wikipedia.org/wiki/Allen_Newell' }
      ]
    end

    context 'using depth first search' do
      it 'raise time-out error when there is a direct link between the pages' do
        stub_const('WikiGame::Engine::TIMEOUT_SECONDS', 1) # it could be 60 seconds the results will be the same
        engine = described_class.new('Breadth-first search', 'Algorithm', dfs_strategy)
        expect { engine.connection_between_pages }.to raise_error(Timeout::Error)
      end
    end

    context 'using breadth first search' do
      it 'find a path when there is direct link between the pages' do
        engine = described_class.new('Breadth-first search', 'Algorithm', bfs_strategy)
        expect(engine.connection_between_pages).to eq(from_bfs_to_algorithm)
      end

      it 'find a path when there is no direct link between the pages and they are close linked' do
        engine = described_class.new('A* search algorithm', 'Allen Newell', bfs_strategy)
        expect(engine.connection_between_pages).to eq(from_a_star_to_allen_newell)
      end

      it 'raise time-out error when there is no direct link between the pages and they are not close linked' do
        stub_const('WikiGame::Engine::TIMEOUT_SECONDS', 1) # it could be 60 seconds the results will be the same
        engine = described_class.new('Benjamin+Franklin', 'Austro-Hungarian_Empire', bfs_strategy)
        expect { engine.connection_between_pages }.to raise_error(Timeout::Error)
      end
    end

    context 'using breadth first search with page rank' do
      it 'find a path when there is no direct link between the pages and they are close linked' do
        engine = described_class.new('A* search algorithm', 'Allen Newell', bfs_page_rank_strategy)
        expect(engine.connection_between_pages).to eq(from_a_star_to_allen_newell)
      end

      it 'find a path when there is no direct link between the pages and they are not close linked' do
        engine = described_class.new('Benjamin+Franklin', 'Austro-Hungarian_Empire', bfs_page_rank_strategy)
        expect(engine.connection_between_pages).to eq(['...'])
      end
    end
  end
end
