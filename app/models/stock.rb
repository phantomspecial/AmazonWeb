class Stock < ApplicationRecord
  has_many :carts
  has_many :orderdetails
  belongs_to :sub_category
end
