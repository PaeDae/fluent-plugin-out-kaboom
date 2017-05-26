require_relative 'values_retriever'

class RecordExploder

	def initialize(values_retriever)
		@values_retriever = values_retriever
	end

	def explode_record(keys, record)
		values = @values_retriever.retrieve_values(keys, record)
 
		key_to_explode = keys.last

		upper_keys = keys.reverse.drop(1).reverse

		new_records = values.map do |value|
			record_copy = Marshal.load(Marshal.dump(record))

			upper_record = record_copy

			upper_keys.each do |key|
				upper_record = upper_record[key]
			end
	
			upper_record[key_to_explode] = value
			record_copy	
		end

		return new_records
	end
end