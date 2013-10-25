PaperTrail::Version.module_eval do
  def self.per_month(month)
		where("created_at > ? AND created_at < ?", month.beginning_of_month, month.end_of_month )
	end

	default_scope -> { order('created_at DESC') }
end