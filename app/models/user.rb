class User < ActiveRecord::Base
  #callbacks
  before_save { self.email = email.downcase }

  #associations
  has_many :events
  has_many :expenses
  
  #validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  #methods
  def joins_dinner?(date)
    events.find_by(date: date, category: "dinner")
  end

  def dinner_cost
    self.events.dinner_count * Stat.average_dinner_cost
  end
end
