Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get '/host/new', to: 'host_navigation#index'
  get '/client/:game_id', to: 'client_navigation#index'
end
