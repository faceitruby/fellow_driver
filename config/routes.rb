# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, skip: %i[registration session],
               path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
               },
               controllers: {
                registrations: 'users/registrations',
                sessions: 'users/sessions',
                omniauth_social: 'users/memberships'
              }

    devise_scope :user do
      post 'users/auth/facebook', to: 'users/omniauth_callbacks#facebook'

      post 'users/signup', to: 'users/registrations#create', as: :user_registration
      patch 'users/signup', to: 'users/registrations#update'
      put 'users/signup', to: 'users/registrations#update'

      post 'users/login', to: 'users/sessions#create', as: :user_session

      post 'users/address_autocomplete/complete', to: 'users/address_autocomplete#complete', as: :address_autocomplete_complete
    end

    get 'brands', to: 'vehicles#brands'
    get 'models/:brand', to: 'vehicles#models'
    resources :cars, except: %i[update new]
    resources :payments, only: %i[create]
    resources :trusted_drivers, only: %i[create destroy]
    resources :trusted_driver_requests, only: %i[create destroy index]
    resources :facebook_friends, only: %i[index]
    get 'trusted_drivers', to: 'trusted_drivers#trusted_drivers'
    get 'trusted_for', to: 'trusted_drivers#trusted_for'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
