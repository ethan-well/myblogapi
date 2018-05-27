class ApiKey < ApplicationRecord
  before_create :generate_access_token
  before_save :set_expiration
  belongs_to :user

  def is_expired?
    expires_at < DateTime.now
  end

  def update_access_token
    self.update_attributes({access_token: SecureRandom.hex, expires_at: DateTime.now + 30})
  end

  private
  def generate_access_token
    self.access_token = SecureRandom.hex
  end

  def set_expiration
    self.expires_at = DateTime.now + 30
  end
end
