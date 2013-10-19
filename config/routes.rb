SassRegistry::Application.routes.draw do
  get 'search', to: 'search#search'

  resources :extensions

  resources :authors, only: [:show, :index]

  resources :users, only: [:edit, :update]

  devise_for :users, path: '/', path_names: {
    sign_in:  'login',
    sign_out: 'logout',
    sign_up:  'signup',
    registration: 'account'
  }, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  root 'home#index'
end
