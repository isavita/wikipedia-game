# frozen_string_literal: true
require 'wiki_game/algorithms/depth_first_search'

RSpec.describe WikiGame::Algorithms::DepthFirstSearch do
  describe '#path_between' do

    context 'basic check for correctness and time of execution' do
      it 'return empty array when the start or/and end pages are not strings' do
        [nil, 2, Object.new].each do |value|
          expect(described_class.new.path_between('London', value)).to eq([])
          expect(described_class.new.path_between(value, 'London')).to eq([])
          expect(described_class.new.path_between(value, value)).to eq([])
        end
      end

      it 'return path with one element when the start and end pages are the same page' do
        expect(described_class.new.path_between('London', 'London')).to eq(['London'])
      end

      it 'return path when the start and end pages are directly reachable' do
        expect(described_class.new.path_between('London', '.london')).to eq(['London', '.london'])
      end
    end

  end
end
