class User < ApplicationRecord
    #associations
    has_many :recipes
    has_many :comments, dependent: :destroy
    # has_many :jwt_tokens

    # def assign_api_key
    #     self.api_key = SecureRandom.uuid
    # end

    has_secure_password

    #validation
    validates :firstname, :lastname, :username, :email, presence: true
    validates :password, presence: true
    validates :email, uniqueness: true
    validates :username, uniqueness: true

end
