class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 13 }
  validates :password, presence: true, length: { minimum: 10 }
end
