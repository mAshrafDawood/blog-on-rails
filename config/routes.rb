Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


  namespace :api do
    namespace :v1 do

      # Register
      post '/register', to: 'users#create'

      # Authentication
      post '/login', to: 'authentication#login'
      post '/logout', to: 'authentication#logout'

      # Password reset
      put '/change_password', to: 'passwords#update'

      # Resources for posts
      resources :posts, only: [:index, :show, :create, :update, :destroy] do
        # Nested resources for comments and likes
        resources :comments, only: [:index, :create, :update, :destroy]
        resource :like, only: [:create, :destroy]
      end

    end
  end

end
