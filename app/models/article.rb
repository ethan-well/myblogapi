class Article < ApplicationRecord
  validates :title, presence: true, length: { in: 2..20 }
  validates :content, presence: true
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :taggeds
  has_many :tags, through: :taggeds
end
