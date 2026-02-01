# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
        path: "auth",
        defaults: { format: :json },
        controllers: {
          registrations: "api/v1/auth/registrations",
          sessions: "api/v1/auth/sessions"
        }

      namespace :auth do
        get  :me,      to: "me#show"
        post :refresh, to: "refresh#create"
        # sign_out já é o destroy do devise session -> DELETE /auth/sign_out
      end

      resources :promos, only: %i[index show create update destroy] do
        collection do
          post :check_link
        end
        member do
          post :verify
          post :report
        end
      end

      namespace :geocoding do
        post :search
        get  :reverse
      end

      resources :stores, only: %i[index] do
        collection do
          get :search
          get :nearby
        end
      end

      namespace :links do
        post :verify
      end

      get "/stats", to: "stats#show"
    end
  end
end
