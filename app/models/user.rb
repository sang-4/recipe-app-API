class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    #associations

    has_many :recipes
    has_many :comments, dependent: :destroy
    has_many :jwt_tokens

    def assign_api_key
        self.api_key = SecureRandom.uuid
    end

    has_secure_password


    validates :firstname, :lastname, :username,presence: true

    #validation
    validates :firstname, :lastname, :username, :email, presence: true

    validates :password, length: { minimum: 6 }
    validates :email, uniqueness: true
    validates :username, uniqueness: true

end
