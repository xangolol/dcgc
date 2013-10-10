class Expense < ActiveRecord::Base
	belongs_to :user

	validates :user_id, :date, :category, :amount, presence: true

	EXPENSE_CATEGORIES = ["food", "common-goods", "other"]
	validates :category, inclusion: { in: EXPENSE_CATEGORIES } 
	validates :note, length: { maximum: 300 }
end
