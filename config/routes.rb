SassRegistry::Application.routes.draw do
  resources :authors
  root 'home#index'
end
