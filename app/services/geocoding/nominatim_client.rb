# app/services/geocoding/nominatim_client.rb
module Geocoding
    class NominatimClient
      BASE = "https://nominatim.openstreetmap.org"
  
      def search(address)
        throttle!
        r = HTTParty.get("#{BASE}/search", query: {
          q: address, format: "jsonv2", limit: 1
        }, headers: headers)
  
        json = JSON.parse(r.body)
        return nil if json.empty?
  
        item = json.first
        {
          latitude: item["lat"].to_f,
          longitude: item["lon"].to_f,
          display_name: item["display_name"],
          confidence: item["importance"].to_f.clamp(0.0, 1.0)
        }
      end
  
      def reverse(lat, lng)
        throttle!
        r = HTTParty.get("#{BASE}/reverse", query: {
          lat: lat, lon: lng, format: "jsonv2"
        }, headers: headers)
  
        json = JSON.parse(r.body)
        return nil if json["error"]
  
        {
          latitude: lat.to_f,
          longitude: lng.to_f,
          display_name: json["display_name"],
          confidence: json.dig("importance").to_f.clamp(0.0, 1.0)
        }
      end
  
      private
  
      def headers
        {
          "User-Agent" => "FraldaAlertaAPI/1.0 (suporte@fraldaalerta.com.br)"
        }
      end
  
      # throttle simples (1 req/s) usando Rails.cache
      def throttle!
        key = "nominatim:last_request_at"
        last = Rails.cache.read(key)
        if last && (Time.now.to_f - last) < 1.0
          sleep(1.0 - (Time.now.to_f - last))
        end
        Rails.cache.write(key, Time.now.to_f, expires_in: 5.minutes)
      end
    end
  end
  