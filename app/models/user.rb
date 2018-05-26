class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 2..255 }
  validates :email, presence: true
  has_many :articles
  has_one :api_key
end
