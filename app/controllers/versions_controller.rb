class VersionsController < ApplicationController
	def index
		@versions = PaperTrail::Version.per_month(selected_month)
	end
end
