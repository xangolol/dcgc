class ExpensesController < ApplicationController
	before_action :correct_user, only: [:edit, :update, :destroy]

	def new
		@expense = current_user.expenses.build

		respond_to do |format|
      format.js
    end
	end

	def create
		expense = current_user.expenses.build(expense_params)

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

	def edit
		respond_to do |format|
      format.js
    end
	end

	def update
		if @expense.update_attributes(expense_params)
			flash[:success] = "Grocery updated"
		else
			flash[:error] = "Something went horribly wrong, please try again"
		end
		redirect_to expenses_path
	end

	def destroy
		if @expense.destroy
			flash[:success] = "Grocery removed"
		else
			flash[:error] = "Something went horribly wrong, please try again"
		end
		redirect_to expenses_path
	end

	#create update action and tests

	private
    def expense_params
      params.require(:expense).permit(:category, :date, :amount, :note)
    end

    def correct_user
      @expense = current_user.expenses.find_by id: params[:id]
      redirect_to root_url if @expense.nil?
    end
end
