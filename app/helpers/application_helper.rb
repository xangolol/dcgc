module ApplicationHelper
	def current_month_navigation_number
		if params[:month] then 
			params[:month].to_i
		else 
			0 
		end 
	end
end
