# frozen_string_literal: true

module WikiGame
  module Analyzers

    class PhraseAnalyzer
      STOP_WORDS = %w(a an the and or at as any for from we they them were was of in on into etc so am are not be been)
      BOOLEAN_TO_INTEGER = { true => 1, false => 0 }.freeze

      class << self
        def calc_similarity(phrase1, phrase2)
          return 0 unless phrase1.is_a?(String) && phrase2.is_a?(String)
          if [phrase1, phrase2].compact.map(&:length).max < 10
            inverse_levenshtein_distance(phrase1, phrase2)
          else
            bag_of_words_distance(phrase1, phrase2)
          end
        end

        def inverse_levenshtein_distance(str1, str2)
          distance = levenshtein_distance(str1, str2)
          return 100 if distance.zero?
          1.0 / distance
        end

        def levenshtein_distance(str1, str2)
          return Float::INFINITY unless str1.is_a?(String) && str2.is_a?(String)
          str1 = str1.downcase
          str2 = str2.downcase
          min, max = [str1.length, str2.length].minmax
          return max if min.zero?
          [
            levenshtein_distance(str1[1..-1], str2) + 1,
            levenshtein_distance(str1, str2[1..-1]) + 1,
            levenshtein_distance(str1[1..-1], str2[1..-1]) + BOOLEAN_TO_INTEGER[str1[0] != str2[0]]
          ].min
        end

        private

        def bag_of_words_distance(phrase1, phrase2)
          phrase1 = phrase1.split(/\s|[.?!_,;:-]/).reject { |w| w.empty? || STOP_WORDS.include?(w) }
          phrase2 = phrase2.split(/\s|[.?!_,;:-]/).reject { |w| w.empty? || STOP_WORDS.include?(w) }
          bag_of_words = phrase1 | phrase2
          phrase1_vector = bag_of_words.map { |w| phrase1.count(w).to_f }
          phrase2_vector = bag_of_words.map { |w| phrase2.count(w).to_f }
          product = dot_product(phrase1_vector, phrase2_vector)
          phrase1_vector_norm = dot_product(phrase1_vector, phrase1_vector)
          phrase2_vector_norm = dot_product(phrase2_vector, phrase2_vector)
          product / (Math.sqrt(phrase1_vector_norm) * Math.sqrt(phrase2_vector_norm))
        end

        def dot_product(vector1, vector2)
          (0...vector1.count).inject(0.0) { |sum, i| sum + vector1[i] * vector2[i] }
        end
      end
    end

  end
end
