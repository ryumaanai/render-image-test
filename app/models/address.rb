class Address < ApplicationRecord
  # <<アソシエーション>>
  belongs_to :order
end
