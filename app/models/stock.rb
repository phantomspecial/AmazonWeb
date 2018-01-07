class Stock < ApplicationRecord
  has_many :carts
  has_many :orderdetails
end
