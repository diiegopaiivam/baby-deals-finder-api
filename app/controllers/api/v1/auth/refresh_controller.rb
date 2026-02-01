# app/controllers/api/v1/auth/refresh_controller.rb
module Api
    module V1
      module Auth
        class RefreshController < Api::V1::BaseController
          before_action :authenticate_user!
  
          def create
            # emitindo um novo token para o mesmo usuário
            token, _payload = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil)
  
            render json: {
              token: token,
              user: { id: current_user.id, email: current_user.email, name: current_user.name, created_at: current_user.created_at }
            }
          end
        end
      end
    end
  end
  