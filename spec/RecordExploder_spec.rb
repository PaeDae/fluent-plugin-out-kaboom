require_relative '../lib/RecordExploder'

RSpec.describe RecordExploder do

	context "given single key and a record" do

		it "explodes record" do
			value1 = "value1"
			value2 = "value2"
			values = [value1, value2]

			values_retriever = double("ValuesRetriever")
			expect(values_retriever).to receive(:retrieve_values).and_return(values)

			record_exploder = RecordExploder.new(values_retriever)

			key = "key"

			record = {key => values}

			keys = [key]

			records = record_exploder.explode_record(keys, record)

			expect(records).to eq([{key => value1}, {key => value2}])
		end
	end

	context "given many keys and a record" do

		it "explodes record" do
			value1 = "value1"
			value2 = "value2"
			values = [value1, value2]

			values_retriever = double("ValuesRetriever")
			expect(values_retriever).to receive(:retrieve_values).and_return(values)

			record_exploder = RecordExploder.new(values_retriever)

			upper_key = "upper_key"
			lower_key = "lower_key"

			record = {upper_key => {lower_key => values}}

			keys = [upper_key, lower_key]

			records = record_exploder.explode_record(keys, record)

			expect(records).to eq([{upper_key => {lower_key => value1}}, {upper_key => {lower_key => value2}}])
		end
	end
end