class Stock < ApplicationRecord
  has_many :carts
  has_many :orderdetails
  has_many :reviews
  scope :autocomplete, ->(term) { where("name LIKE ?", "%#{term}%").order(:name) }
  belongs_to :sub_category
end
