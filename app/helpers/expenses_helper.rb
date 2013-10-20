module ExpensesHelper
	def expenses_categories_array
		Expense.categories.map do |value|
			[value.capitalize, value]
		end
	end
end
