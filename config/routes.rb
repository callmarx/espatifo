Rails.application.routes.draw do

  devise_for :logins,
           path: '',
           path_names: {
             sign_in: 'login',
             sign_out: 'logout',
             registration: 'signup'
           },
           controllers: {
             sessions: 'sessions',
             registrations: 'registrations'
           }

  resources :companies do
    resources :projects, only: [:index, :create] do
      resources :lists, only: [:index, :create]
    end
  end
  resources :lists, only: [:show, :update, :destroy]
  resources :projects, only: [:show, :update, :destroy]

  get '/lists/:id/csv_index', to: 'lists#csv_index'
  post '/lists/:id/graph_data', to: 'lists#graph_data'
  post '/lists/:id/preset', to: 'lists#preset'
  get '/projects', to: 'projects#index_all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
