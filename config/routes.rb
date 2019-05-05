Rails.application.routes.draw do
  resources :clients do
    resources :projects
  end
  get '/clients/:client_id/projects/:id/csv_table/:line_start:line_end', to: 'csv_table#index'
  get '/projects', to: 'projects#index_all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
