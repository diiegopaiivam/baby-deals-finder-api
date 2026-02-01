# app/controllers/api/v1/geocoding_controller.rb
module Api
    module V1
      class GeocodingController < BaseController
        def search
          address = params.require(:address)
          result = Geocoding::NominatimClient.new.search(address)
          return render_error("Endereço não encontrado", {}, status: :not_found) unless result
          render json: result
        end
  
        def reverse
          lat = params.require(:lat)
          lng = params.require(:lng)
          result = Geocoding::NominatimClient.new.reverse(lat, lng)
          render json: result
        end
      end
    end
  end
  