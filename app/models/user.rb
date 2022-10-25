class User < ApplicationRecord
    # has_many :recipes
    # has_many :comments, dependent: :destroy

    has_secure_password

    validates :id, :firstname, :lastname, :username, :email, presence: true
    validates :password_digest, presence: true

end
