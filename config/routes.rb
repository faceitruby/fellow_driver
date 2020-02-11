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
              }

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
