class User < ActiveRecord::Base

  # require "securerandom"
  has_many :microposts, dependent: :destroy
  before_save {self.email = email.downcase}
  before_create :create_remember_token
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},                uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}

  def User.new_remember_token
    # byebug
    SecureRandom.urlsafe_base64
  end


  def self.digest(token)
    Digest::SHA1.hexdigest token.to_s
  end


  def feed
    Micropost.where("user_id = ?", id)
  end


  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
