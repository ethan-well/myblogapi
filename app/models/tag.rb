class Tag < ApplicationRecord
  validates :name, presence: true, length: {in: 2..15}
  has_many :articles, through: :taggeds
end
