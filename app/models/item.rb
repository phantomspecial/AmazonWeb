class Item < ApplicationRecord
  belongs_to :stock, foreign_key: "item_id"

  mount_uploader :image, ImageUploader
end
