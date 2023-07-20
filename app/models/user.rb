class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :messages
  has_many :conversations

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  # validates :avatar, attached: true
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  # before_save :remember

  before_create :create_activation_digest

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_column(:activated, true)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

end
