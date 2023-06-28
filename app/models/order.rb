class Order < ApplicationRecord
  belongs_to :user
  has_one :address
  belongs_to :item
  attr_accessor :token
end
