class Expense < ActiveRecord::Base
	before_save :round_amount
	belongs_to :user

	validates :user_id, :date, :category, :amount, presence: true

	EXPENSE_CATEGORIES = ["food", "common-goods", "other"]
	validates :category, inclusion: { in: EXPENSE_CATEGORIES } 
	validates :note, length: { maximum: 300 }

	default_scope -> { order('date') }

	has_paper_trail

	#gives all the expenses for a month. takes the month as a date
	def self.per_month(month)
		where("date > ? AND date < ?", month.beginning_of_month, month.end_of_month )
	end

	#returns the expense categories
	def self.categories
		EXPENSE_CATEGORIES
	end

	private
		def round_amount
			self.amount = self.amount.round(2)
		end
end
