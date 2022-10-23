class User < ApplicationRecord
    has_secure_password
    has_many :recipes
    has_many :comments
    validates :name, presence: true
    validates :email, presence: true
    validates :email, uniqueness: true 
end
