if Rails.env.development? || Rails.env.production?
    p "Preloading word 2 vec"
    p WordToVecService.get_word
    p "Done"
end