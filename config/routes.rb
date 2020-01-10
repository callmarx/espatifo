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
  get '/data_sets/:id', to: 'data_sets#show_dynamic_content'
end
