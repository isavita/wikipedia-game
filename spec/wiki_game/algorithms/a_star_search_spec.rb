# frozen_string_literal: true
require 'wiki_game/algorithms/dijkstra_search'

RSpec.describe WikiGame::Algorithms::AStarSearch do
  describe '#path_between' do

    context 'basic check for correctness' do
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

      it 'return path between the pages when the end page is reachable from the start page by short path' do
        expect(described_class.new.path_between('London', 'Boris Johnson')).to eq(['London', '.london', 'Boris Johnson'])
      end
    end

    context 'pages that are at least 4 links apart' do
      context 'end page is Philosophy' do
        it 'return path between the pages when is less or equal to 3 links' do
          expect(described_class.new.path_between('Benjamin Franklin', 'Philosophy')).to eq(['Benjamin Franklin', '111th Infantry Regiment (United States)', '110th Infantry Regiment (United Sta...Template:R from ambiguous page', 'Ambiguity', 'A. J. Ayer', '20th-century philosophy', 'Philosophy'])
        end

        it 'return path between the pages when is more than 3 links' do
          expect(described_class.new.path_between('Austro-Hungarian Empire', 'Philosophy')).to eq(['Austro-Hungarian Empire', 'Wikipedia:Piped link', 'Advent calendar', 'A Visit from St. Nicholas', '...', '5 October 1910 Revolution', '5 October 1910 revolution', '1755 Lisbon earthquake', 'Philosophy'])
        end
      end

      it 'return path between the pages when the end page is reachable from the start page by long path' do
        expect(described_class.new.path_between('London', 'Batman')).to eq(['London', '10 Downing Street', '10 Downing Street Guard Chairs', 'Acoustics', 'ANSI/ASA S1.1-2013", ...', 'File comparison', 'America Invents Act', 'Leahy-Smith America Invents Act', 'Acronym', 'Batman'])
      end


      it 'return path when start page is NATO and the end page is Swahili language' do
        expect(described_class.new.path_between('NATO', 'Swahili language')).to eq(['NATO', '1949 anti-NATO riot in Iceland', 'Accession of Iceland to the European Union', '1973 enlarg...sudi', 'Abd Allah ibn Mas\'ud', 'Abdullah ibn Masud', 'Abu Bakr', 'Ab (Semitic)', 'Swahili language'])
      end

      it 'return path when start page is Democratic Republic of the Congo and the end page is Robert McNamara' do
        expect(described_class.new.path_between('Democratic Republic of the Congo', 'Robert McNamara')).to eq(['Democratic Republic of the Congo', '+243', '1st millennium', ''Aho'eitu', 'ʻAhoʻeitu', 'Casuarinace...hairs', 'Antique', 'American Pastoral', '1967 Newark riots', '1967 Detroit riot', 'Robert McNamara'])
      end
    end
  end
end
