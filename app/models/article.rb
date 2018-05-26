class Article < ApplicationRecord
  validates :title, presence: true, length: { in: 2..256 }
  validates :content, presence: true
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :taggeds
  has_many :tags, through: :taggeds
  belongs_to :user
end
