class SubCategory < ApplicationRecord
  belongs_to :category, optional: true
end
