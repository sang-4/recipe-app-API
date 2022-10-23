class Comment < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :recipe, optional: true
end
