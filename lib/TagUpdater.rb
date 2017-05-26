class TagUpdater

	def update_tag(tag, remove_tag_prefix, add_tag_prefix)
		new_tag = tag

		if (remove_tag_prefix && tag.start_with?(remove_tag_prefix))
			new_tag = new_tag.sub(remove_tag_prefix, "")
		end

		if (add_tag_prefix)
			new_tag = "#{add_tag_prefix}#{new_tag}"
		end

		new_tag
	end

end