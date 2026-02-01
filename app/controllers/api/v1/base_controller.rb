# app/controllers/api/v1/base_controller.rb
module Api
    module V1
      class BaseController < ActionController::API
        include ActionController::MimeResponds
  
        rescue_from ActiveRecord::RecordNotFound do
          render json: { error: "Não encontrado" }, status: :not_found
        end
  
        def render_error(message, details = {}, status: :unprocessable_entity)
          render json: { error: message, details: details }, status: status
        end
      end
    end
  end
  