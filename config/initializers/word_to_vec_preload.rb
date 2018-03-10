require 'word_to_vec_service'

v = WordToVecService.get_word
dist = WordToVecService.vector_distance('word', 'word')