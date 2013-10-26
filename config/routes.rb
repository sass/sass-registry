SassRegistry::Application.routes.draw do
  get 'search', to: 'search#search'

  get '/extensions/import', to: 'extensions#import', as: 'import_extension'
  resources :extensions

  resources :authors, only: %w(show index)

  resources :users, only: %w(edit update)

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
