Rails.application.routes.draw do
  resources :clients do
    resources :projects do
      resources :lists
    end
  end
  post '/clients/:client_id/projects/:project_id/lists/:id', to: 'lists#preset'
  get '/projects', to: 'projects#index_all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
