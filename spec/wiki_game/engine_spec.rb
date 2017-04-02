# frozen_string_literal: true
require 'wiki_game/engine'
require 'wiki_game/algorithms/graph_search'
require 'wiki_game/algorithms/breadth_first_search'
require 'wiki_game/algorithms/depth_first_search'

RSpec.describe WikiGame::Engine do
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

    let(:from_london_to_blizerd) do
     [
        { title: 'London', url: 'https://en.wikipedia.org/wiki/London' },
        { title: 'Argentina', url: 'https://en.wikipedia.org/wiki/Argentina' },
        { title: 'Blizzard', url: 'https://en.wikipedia.org/wiki/Blizzard' }
      ]
    end

    let(:benjamin_franklin_to_austroa_hungary) do
      [
        { title: 'Benjamin Franklin', url: 'https://en.wikipedia.org/wiki/Benjamin_Franklin' },
        { title: 'Booker T. Washington', url: 'https://en.wikipedia.org/wiki/Booker_T._Washington' },
        { title: 'Austria-Hungary', url: 'https://en.wikipedia.org/wiki/Austria-Hungary' }
      ]
    end

    [
      ['Depth First Search', WikiGame::Algorithms::DepthFirstSearch.new],
      ['Breadth First Search', WikiGame::Algorithms::BreadthFirstSearch.new]
    ].each do |strategy_name, search_strategy|
      context "using #{strategy_name}" do
        it 'find a path when start and end page is the same page' do
          engine = described_class.new('Algorithm', 'Algorithm', search_strategy)
          expect(engine.connection_between_pages).to eq([{ title: 'Algorithm', url: 'https://en.wikipedia.org/wiki/Algorithm' }])
        end

        it 'find a path when there is direct link between the pages' do
          engine = described_class.new('Breadth-first search', 'Algorithm', search_strategy)
          expect(engine.connection_between_pages).to eq(from_bfs_to_algorithm)
        end

        it 'find a path when there is no direct link between the pages and they are close linked' do
          engine = described_class.new('A* search algorithm', 'Allen Newell', search_strategy)
          expect(engine.connection_between_pages).to eq(from_a_star_to_allen_newell)
        end

        context 'find a path with extended timeout when there is no direct link between the pages and they are not close linked' do
          it 'finding a path from London to Blizzard' do
            engine = described_class.new('London', 'Blizzard', search_strategy)
            expect(engine.connection_between_pages).to eq(from_london_to_blizerd)
          end

          it 'find a path from Benjamin Franklin to Austria-Hungary' do
            engine = described_class.new('Benjamin+Franklin', 'Austria-Hungary', search_strategy)
            expect(engine.connection_between_pages).to eq(benjamin_franklin_to_austroa_hungary)
          end

          xit 'find a path from Benjamin Franklin to Austro-Hungarian Empire' do
            engine = described_class.new('Benjamin+Franklin', 'Austro-Hungarian_Empire', search_strategy)
            expect(engine.connection_between_pages).to eq(['...'])
          end
        end
      end
    end
  end
end
