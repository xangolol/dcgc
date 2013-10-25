class VersionsController < ApplicationController
	def index
		@versions = Version.per_month(selected_month)
	end
end
