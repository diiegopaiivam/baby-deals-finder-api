# app/controllers/api/v1/auth/me_controller.rb
module Api
    module V1
      module Auth
        class MeController < Api::V1::BaseController
          before_action :authenticate_user!
  
          def show
            render json: { id: current_user.id, email: current_user.email, name: current_user.name, created_at: current_user.created_at }
          end
        end
      end
    end
  end
  