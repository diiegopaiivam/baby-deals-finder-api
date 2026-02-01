# app/controllers/api/v1/promos_controller.rb
module Api
    module V1
      class PromosController < BaseController
        before_action :authenticate_user!, only: %i[create update destroy verify report]
        before_action :set_promo, only: %i[show update destroy verify report]
  
        def index
          scope = Promo.active.order(created_at: :desc)
  
          if params[:type].present?
            scope = scope.where(promo_type: Promo.promo_types.fetch(params[:type]))
          end
  
          scope = scope.where(product_brand: params[:brand]) if params[:brand].present?
          scope = scope.where(product_size: params[:size])   if params[:size].present?
  
          if params[:min_discount].present?
            min = params[:min_discount].to_i
            scope = scope.select("*")
                         .select("ROUND(((original_price - promo_price) / NULLIF(original_price,0)) * 100) AS discount")
                         .where("((original_price - promo_price) / NULLIF(original_price,0)) * 100 >= ?", min)
          end
  
          # filtro por distância (lat/lng + radius_km)
          if params[:lat].present? && params[:lng].present?
            radius = (params[:radius_km].presence || 7).to_f
            scope = scope.near([params[:lat].to_f, params[:lng].to_f], radius, units: :km)
          end
  
          page = (params[:page].presence || 1).to_i
          per  = [(params[:per_page].presence || 20).to_i, 100].min
  
          paginated = scope.page(page).per(per)
  
          render json: {
            promos: paginated.map { |p| promo_json(p, params[:lat], params[:lng]) },
            meta: { total: paginated.total_count, page: page, per_page: per }
          }
        end
  
        def show
          render json: promo_json(@promo, params[:lat], params[:lng])
        end
  
        def create
          promo = current_user.promos.new(promo_params)
  
          # promo física: geocodifica se veio full_address
          if promo.physical? && promo.full_address.present? && (promo.latitude.blank? || promo.longitude.blank?)
            result = Geocoding::NominatimClient.new.search(promo.full_address)
            return render_error("Endereço não encontrado", {}, status: :not_found) unless result
  
            promo.latitude  = result[:latitude]
            promo.longitude = result[:longitude]
          end
  
          if promo.save
            render json: promo_json(promo, nil, nil), status: :created
          else
            render_error("Dados inválidos", promo.errors)
          end
        end
  
        def update
          return render_error("Não autorizado", {}, status: :forbidden) unless @promo.user_id == current_user.id
  
          if @promo.update(promo_params)
            render json: promo_json(@promo, nil, nil), status: :ok
          else
            render_error("Dados inválidos", @promo.errors)
          end
        end
  
        def destroy
          return render_error("Não autorizado", {}, status: :forbidden) unless @promo.user_id == current_user.id
          @promo.destroy
          head :no_content
        end
  
        # POST /promos/check_link
        def check_link
          link = params.require(:link)
          normalized = Addressable::URI.parse(link).normalize.to_s
          promo = Promo.find_by(link: normalized)
          render json: { exists: promo.present?, promo_id: promo&.id }
        rescue Addressable::URI::InvalidURIError
          render_error("URL inválida", {}, status: :unprocessable_entity)
        end
  
        # POST /promos/:id/verify
        def verify
          # Aqui você pode trocar por “admin ou votação”.
          # Exemplo simples: só admin.
          return render_error("Não autorizado", {}, status: :forbidden) unless current_user.respond_to?(:admin?) && current_user.admin?
  
          @promo.update!(is_verified: true)
          render json: promo_json(@promo, nil, nil)
        end
  
        # POST /promos/:id/report
        def report
          reason = params.require(:reason)
          pr = @promo.promo_reports.new(user: current_user, reason: reason)
  
          if pr.save
            render json: { id: pr.id }, status: :created
          else
            render_error("Dados inválidos", pr.errors)
          end
        end
  
        private
  
        def set_promo
          @promo = Promo.find(params[:id])
        end
  
        def promo_params
          params.require(:promo).permit(
            :title, :description, :original_price, :promo_price,
            :store_name, :store_address, :promo_type, :link,
            :full_address, :latitude, :longitude,
            :expires_at, :product_brand, :product_size, :image_url
          )
        end
  
        def promo_json(promo, lat, lng)
          distance = promo.respond_to?(:distance) ? promo.distance&.to_f : nil
  
          {
            id: promo.id,
            title: promo.title,
            description: promo.description,
            original_price: promo.original_price.to_f,
            promo_price: promo.promo_price.to_f,
            store_name: promo.store_name,
            store_address: promo.store_address,
            promo_type: promo.promo_type,
            link: promo.link,
            is_verified: promo.is_verified,
            created_at: promo.created_at,
            expires_at: promo.expires_at,
            author_name: promo.user&.name,
            author_id: promo.user_id,
            latitude: promo.latitude,
            longitude: promo.longitude,
            distance: distance,
            product_brand: promo.product_brand,
            product_size: promo.product_size,
            image_url: promo.image_url
          }
        end
      end
    end
  end
  