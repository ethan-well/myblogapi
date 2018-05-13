class Article < ApplicationRecord
  validates :title, presence: true, length: { in: 2..20 }
  validates :content, presence: true, length: { minimum: 100 }
  has_many :article_categories
  has_many :categories, through: :article_categories
  has_many :comments, dependent: :destroy
  has_many :taggeds
  has_many :tags, through: :taggeds
end
