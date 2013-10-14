class ExpensesController < ApplicationController
	#TODO make create, new and index methods

	def index
		@food_expenses = Expense.per_month(selected_month).where(category: "food")
		@common_goods_expenses = Expense.per_month(selected_month).where(category: "common-goods")
	end
end
