# app/controllers/api/v1/links_controller.rb
module Api
    module V1
      class LinksController < BaseController
        def verify
          url = params.require(:url)
          result = Links::Verifier.new.verify(url)
          render json: result
        end
      end
    end
  end
  