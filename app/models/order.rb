class Order < ApplicationRecord
  belongs_to :order
  has_one :addresses
end
