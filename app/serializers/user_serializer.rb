class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :username, :password, :password_confirmation
end
