class User < ApplicationRecord
  has_secure_password
  has_many :wakes

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}
  # passwordカラムにバリデーションを設定してください
  validates :password, {presence: true}
end
