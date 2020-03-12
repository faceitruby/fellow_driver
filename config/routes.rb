Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users,
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
      post 'users/auth/facebook', :to => 'users/omniauth_callbacks#facebook'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
