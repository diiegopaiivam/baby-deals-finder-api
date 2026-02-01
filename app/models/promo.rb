# app/models/promo.rb
class Promo < ApplicationRecord
  enum promo_type: { physical: 0, online: 1 }

  belongs_to :user
  belongs_to :store, optional: true, counter_cache: true
  has_many :promo_reports, dependent: :destroy

  before_validation :normalize_link
  before_validation :infer_store_for_online

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, length: { maximum: 1000 }, allow_blank: true

  validates :original_price, :promo_price,
            presence: true,
            numericality: { greater_than: 0 }

  validates :product_brand, :product_size, :store_name, presence: true

  validate :promo_price_less_than_original
  validate :online_requires_link
  validate :physical_requires_location

  # “store_name” é do swagger; mantenha como string na Promo
  # (e use Store como catálogo opcional)
  attribute :store_name, :string

  validates :link, uniqueness: true, allow_nil: true

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def discount_percent
    return nil if original_price.to_f <= 0
    ((original_price.to_f - promo_price.to_f) / original_price.to_f * 100).round
  end

  private

  def normalize_link
    return if link.blank?
    self.link = Addressable::URI.parse(link).normalize.to_s
  rescue Addressable::URI::InvalidURIError
  end

  def infer_store_for_online
    self.store_address = nil if online?
  end

  def promo_price_less_than_original
    return if original_price.blank? || promo_price.blank?
    errors.add(:promo_price, "deve ser menor que o preço original") if promo_price >= original_price
  end

  def online_requires_link
    return unless online?
    errors.add(:link, "é obrigatório para promo online") if link.blank?
  end

  def physical_requires_location
    return unless physical?
    if full_address.blank? && (latitude.blank? || longitude.blank?)
      errors.add(:full_address, "ou latitude/longitude são obrigatórios para promo física")
    end
  end
end
