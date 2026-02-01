# app/controllers/api/v1/stats_controller.rb
module Api
    module V1
      class StatsController < BaseController
        def show
          total_promos = Promo.count
          active_promos = Promo.active.count
          total_users = User.count
  
          avg_discount = Promo.where.not(original_price: 0).average(
            Arel.sql("((original_price - promo_price) / original_price) * 100")
          )&.to_f
  
          promos_by_brand = Promo.group(:product_brand).count
  
          render json: {
            total_promos: total_promos,
            active_promos: active_promos,
            total_users: total_users,
            active_users_today: 0, # implemente com tracking (ex: ahoy, events)
            average_discount: avg_discount,
            promos_by_brand: promos_by_brand
          }
        end
      end
    end
  end
  