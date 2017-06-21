Rails.application.routes.draw do
  get 'user/show'
  get 'user/new'

  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'user#new'
  post '/signup', to: 'user#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :user

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
