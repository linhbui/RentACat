# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#
require 'bcrypt'

class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  
  after_initialize :session_token_exists
  
  attr_reader :password
  
  has_many :cats
  has_many :requests, class_name: 'CatRentalRequest', foreign_key: :user_id
  
  has_many :cats_requests, through: :cats, source: :cat_rental_requests
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?      
    user.is_password?(password) ? user : nil
  end
    
  def session_token_exists
    self.session_token ||= SecureRandom::urlsafe_base64
  end
  
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!    
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)  
  end
end
