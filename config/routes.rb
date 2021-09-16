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
                  omniauth_social: 'users/memberships',
                  invitations: 'users/invitations'
              }

    devise_scope :user do
      post 'users/auth/facebook', to: 'users/omniauth_callbacks#facebook'

      post 'users/signup', to: 'users/registrations#create', as: :user_registration
      match 'users/signup', to: 'users/registrations#update', via: %i[patch put]

      post 'users/login', to: 'users/sessions#create', as: :user_session
      delete 'users/logout', to: 'users/sessions#destroy'

      post 'users/address_autocomplete/complete', to: 'users/address_autocomplete#complete', as: :address_autocomplete_complete
      post 'users/distance_time/calculate', to: 'users/distance_matrix#calculate', as: :distance_matrix_calculate
    end

    get 'brands', to: 'vehicles#brands'
    get 'models/:brand', to: 'vehicles#models'
    resources :cars, except: %i[update new]
    resources :trusted_drivers, only: %i[create destroy index] do
      get :trusted_for, on: :collection
    end
    resources :trusted_driver_requests, only: %i[create destroy index]
    resources :facebook_friends, only: %i[index]
    get 'families', to: 'families#index'
    resources :notifications, only: %i[index create destroy]
    resources :devices, only: %i[index create destroy]
    resources :notifications_receivers, only: %i[create]
    delete 'notifications_receivers', to: 'notifications_receivers#destroy'
    get '/pushnotification/notify' => 'pushnotification#notify'
    resources :family_connections, only: %i[index update]

    post 'payments/create_customer', to: 'payments#create_customer', as: :create_customer
    post 'payments/create_charge', to: 'payments#create_charge', as: :create_charge
    resources :favourite_locations
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
