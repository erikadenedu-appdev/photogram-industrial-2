Rails.application.routes.draw do
  root "photos#index"



  devise_for :users
  
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos

    get "/:username" => "users#show"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
