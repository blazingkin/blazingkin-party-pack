Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  root 'welcome#index'
  get '/host/new', to: 'host_navigation#index'
  get '/client/', to: 'client_navigation#index'
  get '/client/:game_id', to: 'client_navigation#connect'
end
