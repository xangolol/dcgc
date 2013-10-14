class Expense < ActiveRecord::Base
	before_save :round_amount
	belongs_to :user

	validates :user_id, :date, :category, :amount, presence: true

	EXPENSE_CATEGORIES = ["food", "common-goods", "other"]
	validates :category, inclusion: { in: EXPENSE_CATEGORIES } 
	validates :note, length: { maximum: 300 }

	private
		def round_amount
			self.amount = self.amount.round(2)
		end
end
