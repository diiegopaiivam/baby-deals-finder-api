# app/models/store.rb
class Store < ApplicationRecord
    has_many :promos, dependent: :nullify

    validates :name, presence: true
end