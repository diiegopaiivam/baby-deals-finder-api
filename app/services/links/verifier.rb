# app/services/links/verifier.rb
module Links
    class Verifier
      TRUSTED_DOMAINS = [
        "amazon.com.br", "mercadolivre.com.br", "magazineluiza.com.br",
        "shopee.com.br", "americanas.com.br"
      ].freeze
  
      def verify(url)
        uri = Addressable::URI.parse(url).normalize
        return bad("URL inválida") unless uri&.host
  
        warnings = []
        domain = uri.host.downcase.sub(/\Awww\./, "")
  
        ssl_valid = (uri.scheme == "https")
        warnings << "URL não usa HTTPS" unless ssl_valid
  
        trusted = TRUSTED_DOMAINS.any? { |d| domain == d || domain.end_with?(".#{d}") }
        warnings << "Domínio não está na lista de confiança" unless trusted
  
        {
          is_valid: true,
          is_trusted_domain: trusted,
          domain: domain,
          ssl_valid: ssl_valid,
          warnings: warnings
        }
      rescue Addressable::URI::InvalidURIError
        bad("URL inválida")
      end
  
      private
  
      def bad(msg)
        { is_valid: false, is_trusted_domain: false, domain: nil, ssl_valid: false, warnings: [msg] }
      end
    end
  end
  