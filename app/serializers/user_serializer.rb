class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :first_name, :last_name, :username ,:email, :password, :remember_digest, :activation_digest, :activated, :bio, :messages, :created_at, :updated_at, :avatar, :avatar_url

  attribute :avatar_url do |user|
    user.avatar_url
  end
end
