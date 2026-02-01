module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        def create
          build_resource(sign_up_params)

          resource.save
          if resource.persisted?
            # evita sign_in (que mexe com sessão)
            token, _payload = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)

            render json: {
              token: token,
              user: { id: resource.id, email: resource.email, name: resource.name, created_at: resource.created_at }
            }, status: :created
          else
            render json: { error: "Dados inválidos", details: resource.errors }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
