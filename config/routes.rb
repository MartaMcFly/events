Rails.application.routes.draw do
  resources :events
  resources :charges
  # resources :user
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "events#index"
  post '/subscribe/:id',   to: 'events#subscribe', as: 'subscribe'
  post '/unsubscribe/:id', to: 'events#unsubscribe', as: 'unsubscribe'
end
