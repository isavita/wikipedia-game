# frozen_string_literal: true
require 'wiki_game/algorithms/dijkstra_search'

RSpec.describe WikiGame::Algorithms::DijkstraSearch do
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
          expect(described_class.new.path_between('Benjamin Franklin', 'Philosophy')).to eq(["Benjamin Franklin", "111th Infantry Regiment (United States)", "110th Infantry Regiment (United States)", "109th Infantry Regiment (United States)", "108th Infantry Regiment (United States)", "107th Infantry Regiment (United States)", "107th Infantry Memorial", "103rd Street (IND Eighth Avenue Line)", "103rd Street (disambiguation)", "Template:R from ambiguous page", "Ambiguity", "A. J. Ayer", "20th-century philosophy", "Philosophy"])
        end

        it 'return path between the pages when is more than 3 links' do
          expect(described_class.new.path_between('Austro-Hungarian Empire', 'Philosophy')).to eq(["Austro-Hungarian Empire", "Wikipedia:Piped link", "Advent calendar", "A Visit from St. Nicholas", "'Twas the Night Before Christmas (disambiguation)", "'Twas the Night", "A Christmas Carol (2009 film)", "2010 Kids' Choice Awards", "17 Again (film)", "AFI Catalog of Feature Films", "American Film Institute", "AFI's 10 Top 10", "1924 in film", "1870s in film", "1860 in film", "19th century in film", "Anna Hofman-Uddgren", "August Strindberg", "A Doll's House", "19th-century feminism", "History of feminism", "1975 Icelandic women's strike", "Althing", "Absolute monarchy", "5 October 1910 Revolution", "5 October 1910 revolution", "1755 Lisbon earthquake", "Philosophy"])
        end
      end

      it 'return path between the pages when the end page is reachable from the start page by long path' do
        expect(described_class.new.path_between('London', 'Batman')).to eq(["London", "10 Downing Street", "10 Downing Street Guard Chairs", "Acoustics", "ANSI/ASA S1.1-2013", "American National Standards Institute", "ANSI (disambiguation)", "ANSI art", "ANSI.SYS", "$CLS (environment variable)", "Template:Anchor", "Character entity reference", "List of XML and HTML character entity references", "Acute accent", "Acute (phonetics)", "Grave and acute", "Active articulator", "Speech organ", "Alveolar ridge", "Alveolar consonants", "Wikipedia:Mainspace", "Wikipedia:Namespace", "Data comparison", "File comparison", "America Invents Act", "Leahy-Smith America Invents Act", "Acronym", "Batman"])
      end
    end
  end
end
