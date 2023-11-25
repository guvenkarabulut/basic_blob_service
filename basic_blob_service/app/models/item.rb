class Item < ApplicationRecord
  has_one_attached :item_image do |attachable|
    attachable.variant :default_variant, rotate: [0]
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :cover, resize_to_fill: [500, 100]
  end
end