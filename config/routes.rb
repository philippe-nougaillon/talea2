Rails.application.routes.draw do

  devise_for :users, controllers: { 
    registrations: 'users/registrations'
  }
  
  devise_scope :user do
    authenticated :user do
      root 'interventions#index', as: :authenticated_root
    end
    
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Mount Mission Control Job's engine where you wish to have it accessible
  mount MissionControl::Jobs::Engine, at: "/jobs"
  
  resources :users
  resources :organisations, only: %i[ show edit update ] 
  resources :mail_logs

  resources :interventions do
    member do
      get :accepter
      get :en_cours
      get :terminer
      get :valider
      get :refuser
      get :archiver
    end
  end

  get 'admin/audits'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "interventions#index"

end
