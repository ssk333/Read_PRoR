Rails.application.routes.draw do
  resources :events
  root to: 'welcome#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy',as: :logout

  resources :users, only: :destroy do
    get 'retire'
  end

  resources :events, except: :index do
    resources :tickets, only: [:new, :create, :destroy]
  end
  match '*path' => 'application#error404', via: all
end
