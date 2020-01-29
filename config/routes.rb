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

  resources :reports, except: [:create]
  post '/data_sets/:data_set_id/reports', to: 'reports#create'
  get '/reports/:id/download', to: 'reports#download_csv_preset'

  get '/dashboard/undigested_input', to: 'admin_dashboard#index_my_undigested_input'
  get '/dashboard/undigested_input/:id', to: 'admin_dashboard#show_my_undigested_input'
  post '/dashboard/undigested_input', to: 'admin_dashboard#create_undigested_input'
  put '/dashboard/undigested_input/:id', to: 'admin_dashboard#update_undigested_input'
  patch '/dashboard/undigested_input/:id', to: 'admin_dashboard#update_undigested_input'
end
