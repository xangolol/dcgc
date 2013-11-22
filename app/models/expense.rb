class Expense < ActiveRecord::Base
	#callbacks
	before_save :round_amount

	#TODO refactor these 3 callbacksls s
	after_create do |expense|
		if expense.food?
			Stat.update_total_dinner_cost(expense.amount)
		end
	end

	after_update do |expense|
		if category_changed?
			if category == 'food'
				Stat.update_total_dinner_cost(expense.amount)
			else
				Stat.update_total_dinner_cost(-expense.amount)
			end
		else
			if expense.food?
				Stat.update_total_dinner_cost(expense.amount - expense.amount_was)
			end
		end
	end

	after_destroy do |expense|
		if expense.food?
			Stat.update_total_dinner_cost(-expense.amount)
		end
	end

	#associations
	belongs_to :user
	has_paper_trail

	#validations
	validates :user_id, :date, :category, :amount, presence: true

	EXPENSE_CATEGORIES = ["food", "common-goods", "other"]
	validates :category, inclusion: { in: EXPENSE_CATEGORIES } 
	validates :note, length: { maximum: 300 }

	default_scope -> { order('date') }

	#methods
	#gives all the expenses for a month. takes the month as a date
	def self.per_month(month)
		where("date > ? AND date < ?", month.beginning_of_month, month.end_of_month )
	end

	#returns the expense categories
	def self.categories
		EXPENSE_CATEGORIES
	end

	def food?
		category == 'food'
	end

	private
		def round_amount
			self.amount = self.amount.round(2)
		end

    def update_stats
    	Stat.update_total_dinner_cost self.amount
    end
end
