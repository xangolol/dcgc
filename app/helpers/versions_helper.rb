module VersionsHelper
	def version_array(version)
			array = {}
			array[:changed_by] = User.find_by_id(version.whodunnit).name
			array[:action] = version.event
			array[:class] = version.item_type
			array[:date] = version.created_at
			array[:details] = extract_details(version)
			array
	end

	def extract_details(version)
		if version.item_type == "Event"
			extract_details_for_events(version)
		elsif version.item_type == "Expense"
			extract_details_for_expenses(version)
		end
	end

	def extract_details_for_events(version)
		item = version.reify
		changeset = version.changeset
		case version.event
		when "create"
			category = changeset[:category][1]
			dinner_guest = " (#{changeset[:dinner_guest][1]})" if category == "dinner-guest"
			"#{category}#{dinner_guest} on #{changeset[:date][1]}"
		when "destroy"
			category = item.category
			dinner_guest = " (#{item.dinner_guest})" if category == "dinner-guest"
			"#{category}#{dinner_guest} on #{item.date}"
		end
	end

	def extract_details_for_expenses(version)
		item = version.reify
		changeset = version.changeset
		case version.event
		when "create"
			"#{changeset[:category][1]} (#{number_to_currency(changeset[:amount][1], unit: "&euro; ")}) on #{changeset[:date][1]}"
		when "update"
			if changeset[:amount]
				before_change = number_to_currency(changeset[:amount][0], unit: "&euro; ")
				after_change = number_to_currency(changeset[:amount][1], unit: "&euro; ")
			elsif changeset[:date]
				before_change = changeset[:date][0] 
				after_change = changeset[:date][1]
			elsif changeset[:category]
				before_change = changeset[:category][0] 
				after_change = changeset[:category][1]
			end
			"#{item.category} from (#{before_change}) to (#{after_change}) on #{changeset[:updated_at][1].to_date}"
		when "destroy"
			"#{item.category} (#{number_to_currency(item.amount, unit: "&euro; ")}) on #{item.date}"
		end
	end


	#not finished and not used
	def version_stringify(version)
		item = version.reify
		changed_by = version.whodunnit
		item_type = version.item_type
		item_date = 'temp'

		if item_type == 'Event'
			case version.event
			when "create"
				if item.category == 'dinner'
					version_verb = 'joined dinner'
				elsif item.category == 'dinner-guest'
					version_verb = 'added dinner guest(#{item.dinner_guest})'
				end
			when "destroy"
				if item.category == 'dinner'
					version_verb = 'unjoined dinner'
				elsif item.category == 'dinner-guest'
					version_verb = 'removed dinner guest(#item.dinner_guest)'
				end
			end
		elsif item_type == 'Expense'
		end

		return "#{changed_by} #{version_verb} on #{item_date}"
	end
end
