class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_many :events
  has_many :expenses
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def joins_dinner?(date)
    events.find_by(date: date, category: "dinner")
  end
end
