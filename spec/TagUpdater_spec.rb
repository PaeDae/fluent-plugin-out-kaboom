require_relative '../lib/TagUpdater'

RSpec.describe TagUpdater do

	tag_updater = TagUpdater.new
	
	context "given remove_tag_prefix" do

		context "tag prefix is present in original tag" do

			it "removes tag prefix" do
				original_tag = "prefix.tag"
				remove_tag_prefix = "prefix."

				tag = tag_updater.update_tag(original_tag, remove_tag_prefix, nil)

				expect(tag).to eq("#{original_tag.sub(remove_tag_prefix, "")}")
			end
		end

		context "tag prefix is not present in original tag" do

			it "does not remove tag prefix" do
				original_tag = "different_prefix.tag"
				remove_tag_prefix = "prefix."

				tag = tag_updater.update_tag(original_tag, remove_tag_prefix, nil)

				expect(tag).to eq(original_tag)
			end
		end
	end

	context "when given add tag_prefix" do

		it "adds tag prefix" do
			original_tag = "tag"
			add_tag_prefix = "prefix."

			tag = tag_updater.update_tag(original_tag, nil, add_tag_prefix)

			expect(tag).to eq("#{add_tag_prefix}#{original_tag}")
		end
	end

	context "given remove_tag_prefix and add_tag_prefix" do

		it "removes prefix than adds prefix" do
			original_tag = "old_prefix.tag"
			remove_tag_prefix = "old_prefix."
			add_tag_prefix = "new_prefix."

			tag = tag_updater.update_tag(original_tag, remove_tag_prefix, add_tag_prefix)

			expect(tag).to eq("#{add_tag_prefix}#{original_tag.sub(remove_tag_prefix, "")}")
		end
	end

end