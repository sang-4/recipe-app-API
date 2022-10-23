class User < ApplicationRecord
    has_many :recipes

    has_secure_password

    validates :first_name, :last_name, :email, :username, presence: true
    # validates :username, presence: true, uniqueness: true
    # validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true

end
