class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 2..255 }
  validates :email, presence: true
  has_many :articles
  has_one :api_key

  def generate_or_update_api_key
    if api_key.present?
      api_key.update_access_token if api_key.is_expired?
      api_key
    else
      ApiKey.create(user_id: id)
    end
  end
end
