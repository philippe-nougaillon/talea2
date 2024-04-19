Rails.application.routes.draw do
  get 'admin/audits'
  devise_for :users, controllers: { 
    registrations: 'users/registrations'
  }
  
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
    
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  
  resources :users
  resources :organisations
  resources :interventions do
    member do
      get :accepter
      get :en_cours
      get :realiser
      get :valider
      get :archiver
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"
end
