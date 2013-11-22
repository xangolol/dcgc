class StatsController < ApplicationController
	def balance
		@balance = Stat.get_total_dinner_cost
		#TODO implement balance overview
	end
end