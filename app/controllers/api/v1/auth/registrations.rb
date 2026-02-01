# app/controllers/api/v1/auth/registrations.rb
module Api
    module V1
      module Auth
        class RegistrationsController < Devise::RegistrationsController
          respond_to :json
  
          private
  
          def respond_with(resource, _opts = {})
            if resource.persisted?
              render json: {
                token: request.env["warden-jwt_auth.token"],
                user: user_json(resource)
              }, status: :created
            else
              render json: { error: "Dados inválidos", details: resource.errors }, status: :unprocessable_entity
            end
          end
  
          def user_json(u)
            { id: u.id, email: u.email, name: u.name, created_at: u.created_at }
          end
        end
      end
    end
  end
  