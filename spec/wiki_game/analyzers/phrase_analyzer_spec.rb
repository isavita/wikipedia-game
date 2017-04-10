# frozen_string_literal: true
require 'wiki_game/analyzers/phrase_analyzer'

RSpec.describe WikiGame::Analyzers::PhraseAnalyzer do
  describe '.levenshtein_distance' do

    context 'basic input/output checks' do
      it 'returns Infinity when one/both of the phrase/s is/are not a string' do
        [nil, 3.14, Object.new].each do |value|
          expect(described_class.levenshtein_distance(value, 'America')).to eq(Float::INFINITY)
          expect(described_class.levenshtein_distance('America', value)).to eq(Float::INFINITY)
          expect(described_class.levenshtein_distance(value, value)).to eq(Float::INFINITY)
        end
      end

      it 'if the strings are equal the distance is zero' do
        expect(described_class.levenshtein_distance('America', 'America')).to eq(0)
      end

      it 'ignores case of the strings' do
        expect(described_class.levenshtein_distance('AMeRica', 'amerIcA')).to eq(0)
      end
    end

    context 'distance between similar words' do
      it 'distance between "kitten" and "sitting"' do
        expect(described_class.levenshtein_distance('kitten', 'sitting')).to eq(3)
      end
    end

  end

  describe '.inverse_levenshtein_distance' do
    it 'if the strings are equal the distance is 100' do
      expect(described_class.inverse_levenshtein_distance('America', 'America')).to eq(100)
    end

     it 'distance between "kitten" and "sitting"' do
      expect(described_class.inverse_levenshtein_distance('kitten', 'sitting')).to be_within(0.001).of(0.333)
    end
  end

  describe '.calc_similarity' do

    context 'basic input/output checks' do
      it 'returns 0 when one/both of the phrase/s is/are not a string' do
        [nil, 3.14, Object.new].each do |value|
          expect(described_class.calc_similarity(value, 'America')).to eq(0)
          expect(described_class.calc_similarity('America', value)).to eq(0)
          expect(described_class.calc_similarity(value, value)).to eq(0)
        end
      end
    end

    context 'given two similar phrases should return high number for similarity' do
      it 'return 1 for the same phrases "Byzantine Empire" and "Byzantine Empire"' do
        expect(described_class.calc_similarity('Byzantine Empire', 'Byzantine Empire')).to be_within(0.001).of(1)
      end

      it 'return bigger than 0.8 weight but smaller than 0.9 for the phrases "Hungarian Empire" and "Austro-Hungarian Empire"' do
        similarity = described_class.calc_similarity('Hungarian Empire', 'Austro-Hungarian Empire')
        expect(similarity).to be > 0.8
        expect(similarity).to be < 0.9
      end
    end

    context 'given two quite different phrases should return small number for similarity' do
      it 'return small than 0.05 weight for linguistically different phrases "Byzantine Empire" and "Europe"' do
        expect(described_class.calc_similarity('Byzantine Empire', 'Europe')).to be < 0.05
      end

       it 'return smaller than 0.4 and bigger than 0.3 weight for the phrases "Hungary" and "Hungarian"' do
        similarity = described_class.calc_similarity('Hungary', 'Hungarian')
        expect(similarity).to be < 0.4
        expect(similarity).to be > 0.3
      end

      it 'return smaller than 0.5 and bigger than 0.4 weight for the phrases "History of the Byzantine Empire" and "Austro-Hungarian Empire"' do
        similarity = described_class.calc_similarity('History of the Byzantine Empire', 'Hungarian Empire')
        expect(similarity).to be < 0.5
        expect(similarity).to be > 0.2
      end
    end

  end
end
