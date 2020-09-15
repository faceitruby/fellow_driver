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
    end

    get 'brands', to: 'vehicles#brands'
    get 'models/:brand', to: 'vehicles#models'
    resources :cars, except: %i[update new]
    resources :payments, only: %i[create]
    # get 'rides/family_members', to: 'rides#family_members'
    # post 'rides', to: 'rides#create'
    resources :trusted_drivers, only: %i[create destroy index] do
      get :trusted_for, on: :collection
    end
    resources :trusted_driver_requests, only: %i[create destroy index]
    resources :facebook_friends, only: %i[index]
    scope module: :rides do
      get 'rides/:id/template' => 'templates#show'
      resources :templates, only: :index
      resources :rides, shallow: true, only: %i[index show create destroy]
      get 'distance_matrix' => 'rides#distance_matrix'
      get 'rides/:id/candidates' => 'candidates#index'
      post 'rides/:id/accept' => 'candidates#create'
      post 'rides/:id/dismiss' => 'candidates#deny'
      post 'candidates/:id/accept' => 'candidates#accept'
      post 'candidates/:id/dismiss' => 'candidates#dismiss'
    end

    # get 'rides/test' => 'rides/test'
    get 'families', to: 'families#index'
    resources :notifications, only: %i[index create destroy]
    resources :devices, only: %i[index create destroy]
    resources :notifications_receivers, only: %i[create]
    delete 'notifications_receivers', to: 'notifications_receivers#destroy'
    get '/pushnotification/notify' => 'pushnotification#notify'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
