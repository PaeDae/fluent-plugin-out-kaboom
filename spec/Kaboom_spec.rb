require 'fluent/test'
require_relative '../lib/out_kaboom.rb'
require_relative '../lib/RecordExploder'

RSpec.describe Fluent::Kaboom do

	context "given no tag modifications" do

		it "throws config error" do
			Fluent::Test.setup

			key = "key"

			configuration = "key #{key}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"			

			expect { Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration) }.to raise_error(Fluent::ConfigError)
		end
	end

	context "given tag modification and tag override" do

		it "throws config error" do
			Fluent::Test.setup

			key = "key"
			add_tag_prefix = "prefix."
			tag_override = "new_tag"

			configuration = "key #{key}\nadd_tag_prefix #{add_tag_prefix}\ntag #{tag_override}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"			

			expect { Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration) }.to raise_error(Fluent::ConfigError)
		end
	end

	context "given malformed key" do

		it "throws config error" do
			Fluent::Test.setup

			key = 'key"'
			add_tag_prefix = "prefix."

			configuration = "key #{key}\nadd_tag_prefix #{add_tag_prefix}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"

			expect { Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration) }.to raise_error(Fluent::ConfigError)
		end
	end
	
	context "given tag override" do
		
		it "replaces tag" do
			Fluent::Test.setup

			key = "key"
			tag_override = "new_tag"

			configuration = "key #{key}\ntag #{tag_override}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"			
			original_record = {"key" => ["value1", "value2"]}

			new_tag = "new_tag"
			new_record = "new_record"

			expect(keys_validator).to receive(:keys_are_valid?).with([key], original_record).and_return(true)
			expect(record_exploder).to receive(:explode_record).with([key], original_record).and_return([new_record])

			driver = Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration)

			time = Time.now

			driver.expect_emit(new_tag, time, new_record)

			thread = Thread.new { driver.run() }

			driver.emit(original_record, time)

			thread.join
		end
	end

	context "given tag modification" do
		
		it "replaces tag" do
			Fluent::Test.setup

			key = "key"
			add_tag_prefix = "prefix."

			configuration = "key #{key}\nadd_tag_prefix #{add_tag_prefix}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"			
			original_record = {"key" => ["value1", "value2"]}

			new_tag = "new_tag"
			new_record = "new_record"

			expect(tag_updater).to receive(:update_tag).with(original_tag, nil, add_tag_prefix).and_return(new_tag)
			expect(keys_validator).to receive(:keys_are_valid?).with([key], original_record).and_return(true)
			expect(record_exploder).to receive(:explode_record).with([key], original_record).and_return([new_record])

			driver = Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration)

			time = Time.now

			driver.expect_emit(new_tag, time, new_record)

			thread = Thread.new { driver.run() }

			driver.emit(original_record, time)

			thread.join
		end
	end

	context "given invalid key" do
		
		it "replaces tag" do
			Fluent::Test.setup

			key = "invalid_key"
			add_tag_prefix = "prefix."

			configuration = "key #{key}\nadd_tag_prefix #{add_tag_prefix}\n"

			record_exploder = double(RecordExploder)
			tag_updater = double(TagUpdater)
			keys_validator = double(KeysValidator)

			allow(TagUpdater).to receive(:new).and_return(tag_updater)
			allow(KeysValidator).to receive(:new).and_return(keys_validator)
			allow(RecordExploder).to receive(:new).and_return(record_exploder)

			kaboom = Fluent::Kaboom.new

			original_tag = "tag"			
			original_record = {"key" => ["value1", "value2"]}

			new_tag = "new_tag"
			new_record = "new_record"

			expect(tag_updater).to receive(:update_tag).with(original_tag, nil, add_tag_prefix).and_return(new_tag)
			expect(keys_validator).to receive(:keys_are_valid?).with([key], original_record).and_return(false)

			driver = Fluent::Test::OutputTestDriver.new(kaboom, original_tag).configure(configuration)

			time = Time.now

			driver.expect_emit(new_tag, time, original_record)

			thread = Thread.new { driver.run() }

			driver.emit(original_record, time)

			thread.join
		end
	end
end