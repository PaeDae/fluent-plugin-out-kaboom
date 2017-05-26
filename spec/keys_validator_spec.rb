require_relative '../lib/keys_validator'

RSpec.describe KeysValidator do

	keys_validator = KeysValidator.new

	context "when given one key" do

		it "validates keys" do
			key = 'key'
		
			keys = ['key']

			value = 'value'
			record = {key => value}

			keys_are_valid = keys_validator.keys_are_valid?(keys, record)

			expect(keys_are_valid).to be true
		end
	end

	context "when given many keys" do
		
		it "validates keys" do
			upper_key = 'upper_key'
			lower_key = 'lower_key'

			keys = [upper_key, lower_key]

			value = 'value'

			record = {upper_key => {lower_key => value}}

			keys_are_valid = keys_validator.keys_are_valid?(keys, record)

			expect(keys_are_valid).to be true
		end
	end

	context "when a key does not exist" do

		it "does not validate" do
			key = 'key'
		
			keys = ['different_key']

			value = 'value'
			record = {key => value}

			keys_are_not_valid = keys_validator.keys_are_valid?(keys, record) === false

			expect(keys_are_not_valid).to be true
		end
	end

	context "when keys are out of order" do

	 	it "does not validate" do
			upper_key = 'upper_key'
			lower_key = 'lower_key'

			keys = [upper_key, lower_key]

			value = 'value'

			record = {lower_key => {upper_key => value}}
		
			keys_are_not_valid = keys_validator.keys_are_valid?(keys, record) === false

			expect(keys_are_not_valid).to be true
		end
	end
end