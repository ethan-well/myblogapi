class Comments < ApplicationRecord
  validates :content, presence: true, length: { maximum: 150 }
  validates :article_id, presence: true
  belongs_to :article
end
