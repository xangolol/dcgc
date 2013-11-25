class StatsController < ApplicationController
	def balance
		@balance = Stat.get_total_dinner_cost
		@users = User.all
	end
end