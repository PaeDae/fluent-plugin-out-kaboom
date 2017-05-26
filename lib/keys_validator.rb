class KeysValidator

	def keys_are_valid?(keys, record)
		current_record = record

		keys.each do |key|

			if (!current_record.key?(key))
				return false
      end

			current_record = current_record[key]
		end

		return true
  end
end