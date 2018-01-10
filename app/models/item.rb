class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :sub_category, optional: true
end
