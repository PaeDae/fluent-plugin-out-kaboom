require_relative '../lib/ValuesRetriever'

RSpec.describe ValuesRetriever do
	
	context "when given one key" do

		it "retrieves values" do
			values_retriever = ValuesRetriever.new
			
			key = "key"

			keys = [key]
		
			value1 = "value1"
			value2 = "value2"

			record = {key => [value1, value2]}

			values = values_retriever.retrieve_values(keys, record)

			expect(values).to eq([value1, value2])	
		end
	end

	context "when given many keys" do

		it "retrieves values" do
			values_retriever = ValuesRetriever.new

			upper_key = "upper_key"
			lower_key = "lower_key"

			keys = [upper_key, lower_key]
		
			value1 = "value1"
			value2 = "value2"

			record = {upper_key => {lower_key => [value1, value2]}}

			values = values_retriever.retrieve_values(keys, record)

			expect(values).to eq([value1, value2])
		end
	end
end