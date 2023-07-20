Rails.application.routes.draw do
  
  # resources :conversations do
  #   resources :messages
  # end

  namespace :api do
    resources :users, only: [:index,:show, :new, :create, :edit, :update, :destroy] do
      resources :conversations do
        resources :messages
      end
      resources :messages
    end
    resources :conversations do
      resources :messages
    end
    resources :messages
  end

  resources :messages
  resources :account_activations, only: [:edit]

  get 'login', to: 'api/sessions#new'
  post 'login', to: 'api/sessions#create'
  delete 'logout', to: 'api/sessions#destroy'
  
  # action cable server
  mount ActionCable.server => "/cable"
end
