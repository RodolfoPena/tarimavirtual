Rails.application.routes.draw do
  
  devise_for :users
  resources :users do
    resources :shows do
      member do
        get 'show_access'
      end
    end
  end
  get 'pages/select', to: 'pages#select'
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
