class Stock < ApplicationRecord
  has_many :carts
  has_many :orderdetails

  scope :autocomplete, ->(term) { where("name LIKE ?", "%#{term}%").order(:name) }
end
