class User < ApplicationRecord
    has_many :recipes
    has_many :comments, dependent: :destroy

    has_secure_password

    validates :first_name, :last_name, :email, :username, presence: true
    validates :password_digest, presence: true

end
