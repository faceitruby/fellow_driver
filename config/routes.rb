# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, skip: %w[registration],
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
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
