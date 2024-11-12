Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions',  registrations: 'users/registrations' }

  authenticated :user do
    get 'users/new_member', to: 'users/registrations#new_member', as: 'new_member_user'
    post 'users/create_member', to: 'users/registrations#create_member', as: 'create_member_user'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :teams do
    resources :members, only: %i[index show new create destroy], defaults: { format: :html }
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "teams#index"
end
