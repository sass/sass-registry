SassRegistry::Application.routes.draw do
  resources :extensions

  resources :authors, only: [:show, :index]

  resources :users, only: [:edit, :update]

  devise_for :users, path: '/', path_names: {
    sign_in:  'login',
    sign_out: 'logout',
    sign_up:  'signup',
    registration: 'account'
  }

  root 'home#index'
end
