class User < ApplicationRecord
  has_secure_password
  has_many :wakes

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}
  # passwordカラムにバリデーションを設定してください
  validates :password, {presence: true}

  def generate_token
    JWT.encode({ user_id: id, jti: jti }, Rails.application.secrets.secret_key_base)
  end

  def generate_jti
    self.jti = SecureRandom.uuid
  end

  def password_required?
    new_record? || password.present?
  end

end
