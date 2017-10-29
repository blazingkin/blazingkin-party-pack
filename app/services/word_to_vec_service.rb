require 'word2vec/native_model'
class WordToVecService

    MODEL = Word2Vec::NativeModel.parse_file('data/gutenberg-vector.bin')

    def self.nearest_neighbors(word)
        MODEL.nearest_neighbors([word])
    end

    def self.vector_distance(word1, word2)
        v_word1 = MODEL.vectors[MODEL.index(word1)]
        v_word2 = MODEL.vectors[MODEL.index(word2)]
        distance = 0
        (0..(MODEL.vector_dimensionality-1)).each do |i|
            distance += (v_word1[i] - v_word2[i]) ** 2
        end
        distance ** 0.5
    end

    def self.get_word
        MODEL.vocabulary[rand(10000)]
    end

    def self.has_word?(word)
        MODEL.index(word) != nil
    end

end