Rails.application.routes.draw do
  resource :profile, only: %i{show edit update}

  get "/books/:id" => "books#show"
  resources :publishers do
    resources :books

    member do
      get 'detail'
    end

    collection do
      get 'search'
    end
  end
end
