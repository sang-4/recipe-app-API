class User < ApplicationRecord
    has_many :recipes
    has_many :comments, dependent: :destroy

    has_secure_password

    validates :firstname, :lastname, :username, :email, presence: true
    validates :password, length: { minimum: 6 }

end
