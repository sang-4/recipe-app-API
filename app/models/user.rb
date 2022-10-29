class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :recipes
    has_many :comments, dependent: :destroy

    has_secure_password

    validates :firstname, :lastname, :username,presence: true
    validates :password, length: { minimum: 6 }
    validates :email, uniqueness: true

end
