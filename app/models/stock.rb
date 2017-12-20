class Stock < ApplicationRecord
  has_many :items, primary_key: "item_id", foreign_key:"item_id"
end
