Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static#home"

  resources :games, only: [:new, :create, :destroy] do
    collection do
      get 'play', to: "games#play", as: :play
      patch "add_score", to: "games#add_score", as: :add_score
    end
  end
end
