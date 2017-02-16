Rails.application.routes.draw do
  root 'organizations#index'
  resources :organizations
  namespace :manage do
    namespace :metadata do
      resources :categories do
        get 'parent_params', on: :member
        resources :properties
      end
    end
  end

  namespace :my do
    resources :organizations
  end
end
