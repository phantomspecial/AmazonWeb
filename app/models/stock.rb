class Stock < ApplicationRecord
  has_many :carts
  has_many :orderdetails
  has_many :reviews
end
