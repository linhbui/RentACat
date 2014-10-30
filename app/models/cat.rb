# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string(255)      not null
#  name        :string(255)      not null
#  sex         :string(255)      not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer          not null
#

class Cat < ActiveRecord::Base
  SEX = ["M", "F"]
  COLOR = ["black", "brown", "gray", "white", "chocolate", "calico", "tortie"]
  
  validates :sex, presence: true, inclusion: { in: SEX }
  validates :color, presence: true, inclusion: { in: COLOR }
  validates :birth_date, :user_id, :name, presence: true
  validate :on_or_before_today
  
  has_many :cat_rental_requests, dependent: :destroy
  
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  

  def on_or_before_today
    if !self.birth_date.nil? && self.birth_date > Date.today 
      errors[:birth_date] << "is invalid"
    end
  end
  
  def age
    (Date.today - self.birth_date).numerator/365
  end
end
