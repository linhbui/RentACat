# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string(255)      default("PENDING"), not null
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  STATUS = ["PENDING", "APPROVED", "DENIED"]
  
  validates :cat_id, :user_id, presence: true
  validates :status, presence: true, inclusion: {in: STATUS}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :no_overlapping_approved_requests 
  validate :end_date_cannot_be_before_start_date
  
  belongs_to :cat
  belongs_to :user
  
  def self.order_by_start_date
    order(:start_date)
  end
  
  def approve!
    overlaps = self.overlapping_approved_requests.length
    if overlaps > 0
      raise 'HELL'
    else
      CatRentalRequest.transaction do 
        self.status = "APPROVED"
        self.save
        self.overlapping_pending_requests.each do |request|
          request.deny!
        end
      end
    end
  end
  
  def pending?
    self.status == 'PENDING'
  end
  
  def deny!
    self.status = "DENIED"
    self.save!
  end

  def overlapping_requests
    query = <<-SQL
      (
      (start_date BETWEEN '#{self.start_date}' AND '#{self.end_date}')
    OR
      (end_date BETWEEN '#{self.start_date}' AND '#{self.end_date}')
    OR
      (start_date >= '#{self.start_date}' AND end_date <= '#{self.end_date}')
    OR
      (start_date <= '#{self.start_date}' AND end_date >= '#{self.end_date}')
      )
    AND
      cat_id = '#{self.cat_id}'
    SQL
        #returns all requests that would be overlapping with our new request
    CatRentalRequest.select('cat_rental_requests.*').where(query)
  end
  
  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end
  
  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  
  def no_overlapping_approved_requests
    unless start_date.blank? || end_date.blank? || cat_id.blank? || self.status == 'DENIED'
      if overlapping_approved_requests.length > 0
        errors[:requests] << "can't overlap"
      end
    end
  end
  
  def end_date_cannot_be_before_start_date
    unless start_date.blank? || end_date.blank?
      if start_date > end_date
        errors[:requests] << "can't have invalid dates"
      end
    end
  end
end
