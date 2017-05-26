class ValuesRetriever

	def retrieve_values(keys, record)
		current_record = record

		keys.each do |key|
			current_record = current_record[key]
		end

		return current_record
	end
end