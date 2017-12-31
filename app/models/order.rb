class Order < ApplicationRecord
  has_many :orderdetails
  belongs_to :user
end
