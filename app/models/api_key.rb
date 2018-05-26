class ApiKey < ApplicationRecord
  before_create :generate_access_token
  before_save :set_expiration
  belongs_to :user

  private
  def generate_access_token
    self.access_token = SecureRandom.hex
  end

  def set_expiration
    self.expires_at = DateTime.now+30
  end
end
