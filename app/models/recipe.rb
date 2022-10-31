class Recipe < ApplicationRecord
    # belongs_to :user
    has_many :comments, through: :user
end
