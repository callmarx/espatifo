Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'user/sessions',
      registrations: 'user/registrations'
    }

  get '/data_sets', to: 'data_sets#index'
  get '/data_sets/:id', to: 'data_sets#show'
  get '/data_sets/:id/:subject_id', to: 'data_sets#show_subject'
  post '/data_sets/:id/list', to: 'data_sets#list'
  post '/data_sets/:id/stats', to: 'data_sets#stats'

  resources :reports
  get '/reports/:id/download', to: 'reports#download_csv_preset'
end
