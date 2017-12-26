require 'word2vec/native_model'
class WordToVecService

    MODEL = Word2Vec::NativeModel.parse_file(ENV['GUTENBERG_VECTOR_LOCATION'])

    def self.nearest_neighbors(word)
        MODEL.nearest_neighbors([word])
    end

    def self.vector_distance(word1, word2)
        v_word1 = MODEL.vectors[MODEL.index(word1)]
        v_word2 = MODEL.vectors[MODEL.index(word2)]
        l_n_norm(v_word1, v_word2, 2.0)
    end

    def self.op_on_vectors(word1, word2, op=(lambda {|x,y| x + y}))
        v_word1 = MODEL.vectors[MODEL.index(word1)]
        v_word2 = MODEL.vectors[MODEL.index(word2)]
        Array.new(MODEL.vector_dimensionality) { |i| op.call(v_word1[i], v_word2[i]) }
    end

    def self.distance_to_vector(vector, word)
        v_word = MODEL.vectors[MODEL.index(word)]
        l_n_norm(v_word, vector, 2.0)
    end

    def self.get_word
        MODEL.vocabulary[rand(10000)]
    end

    def self.has_word?(word)
        MODEL.index(word) != nil
    end

    private

    def self.l_n_norm(vec1, vec2, l)
        distance = 0
        (0..(MODEL.vector_dimensionality-1)).each do |i|
            distance += (vec1[i] - vec2[i]) ** l
        end
        distance ** (1/l)
    end

end