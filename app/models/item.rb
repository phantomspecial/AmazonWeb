class Item < ApplicationRecord
  has_many :stocks

  mount_uploader :image, ImageUploader
end
