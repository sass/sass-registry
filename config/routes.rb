SassRegistry::Application.routes.draw do
  devise_for :users, path: '/', path_names: {
    sign_in:  'login',
    sign_out: 'logout',
    sign_up:  'signup',
    registration: 'account'
  }

  resources :authors, only: [:show, :index]

  root 'home#index'
end
