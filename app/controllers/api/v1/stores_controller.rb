# app/controllers/api/v1/stores_controller.rb
module Api
    module V1
      class StoresController < BaseController
        def index
          stores = Store.order(name: :asc)
          render json: stores.map { |s| store_json(s) }
        end
  
        def search
          q = params.require(:q)
          stores = Store.where("name ILIKE ?", "%#{q}%").order(name: :asc)
          render json: stores.map { |s| store_json(s) }
        end
  
        def nearby
          lat = params.require(:lat).to_f
          lng = params.require(:lng).to_f
          radius = (params[:radius_km].presence || 7).to_f
  
          stores = Store.near([lat, lng], radius, units: :km).order(name: :asc)
          render json: stores.map { |s| store_json(s) }
        end
  
        private
  
        def store_json(s)
          {
            id: s.id,
            name: s.name,
            address: s.address,
            latitude: s.latitude,
            longitude: s.longitude,
            is_online: s.is_online,
            website_url: s.website_url,
            promo_count: s.promos_count
          }
        end
      end
    end
  end
  