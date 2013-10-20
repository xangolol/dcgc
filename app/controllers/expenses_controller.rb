class ExpensesController < ApplicationController

	def new
		@expense = current_user.expenses.build

		respond_to do |format|
      format.js
    end
	end

	def create
		expense = current_user.expenses.build(event_params)

		if expense.save
      flash[:success] = "Your grocery has been added"
    else
      flash[:error] = "Something went horribly wrong, please try again (ps don't blame juriaan)"
    end
    redirect_to expenses_path
	end

	def index
		@food_expenses = Expense.per_month(selected_month).where(category: "food")
		@common_goods_expenses = Expense.per_month(selected_month).where(category: "common-goods")
	end

	private
    def event_params
      params.require(:expense).permit(:category, :date, :amount, :note)
    end
end
