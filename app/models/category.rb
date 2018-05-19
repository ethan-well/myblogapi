class Category < ApplicationRecord
  validates :name, presence: true, length: {in: 2..15 }
  has_many :articles
end
