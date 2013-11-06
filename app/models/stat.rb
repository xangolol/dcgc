class Stat < ActiveRecord::Base
	#methods
	def self.update_total_dinner_cost cost
		total = Stat.find_by_name "total-dinner-cost"
		value = total.value + cost
		total.update_attribute('value', value)
	end

	#TODO might need to change
	def self.average_dinner_cost
		get_total_dinner_cost/Event.dinner_count
	end

	#this method should only be used when the total needs to be recalculated
	def self.calculate_total_dinner_cost
		total = 0
		Expense.where("category = 'food'").each do |expense|
			total += expense.amount
		end
		Stat.find_by_name("total-dinner-cost").update_attribute('value', total)
	end

	#dynamic methods
	Stat.all.each do |stat|
		stat_name = stat.name.gsub('-', '_')
		define_singleton_method("get_#{stat_name}") do
			Stat.find_by_name(stat.name).value
		end
	end

	private
end
