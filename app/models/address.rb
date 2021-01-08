class Address < ApplicationRecord
  belongs_to :order
  enum addressType: %w[shipping billing sender]
end
