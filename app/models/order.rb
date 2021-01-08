class Order < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :line_items, dependent: :destroy
end
