Rails.application.routes.draw do
  get "/books/:id" => "books#show"
  resources :publishers
end
