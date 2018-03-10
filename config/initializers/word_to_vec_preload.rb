require 'word_to_vec_service'

if ENV['GUTENBERG_VECTOR_LOCATION'].present?
    v = WordToVecService.get_word
    dist = WordToVecService.vector_distance('word', 'word')
end