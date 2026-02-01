# app/controllers/api/v1/auth/sessions.rb
module Api
    module V1
      module Auth
        class SessionsController < Devise::SessionsController
          respond_to :json
  
          private
  
          def respond_with(resource, _opts = {})
            render json: {
              token: request.env["warden-jwt_auth.token"],
              user: { id: resource.id, email: resource.email, name: resource.name, created_at: resource.created_at }
            }, status: :ok
          end
  
          def respond_to_on_destroy
            head :no_content
          end
        end
      end
    end
  end
  