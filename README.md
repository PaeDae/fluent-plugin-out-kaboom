# fluent-plugin-out-kaboom

A Fluentd plugin for exploding JSON array elements

## Configuration Options
|Argument|Description|Required?|Default|
|----|----|----|----|
|key|The key of the array to explode|Yes|N/A|
|tag|The tag to use for emitted messages|No|Defers to add_tag_prefix or remove_tag_prefix|
|remove_tag_prefix|The prefix to remove from the tags of emitted messages|No|N/A|
|add_tag_prefix|The prefix to add to the tags of emitted messages|No|N/A|

If you do not specify `tag`, you must specify `remove_tag_prefix`, `add_tag_prefix`, or both. `remove_tag_prefix` will be applied before `add_tag_prefix`.

## Example Usage

Consider a Fluentd message with the tag `users` and the following contents:

`{"user": {"first_name": "John", "last_name": "Smith", "favorite_movies": ["John Wick", "Robocop", "Blade Runner"]}}`

If you need to run analytics on this data via a database like Redshift, which does not support Arrays, `favorite_movies` needs to be exploded. We can use a Fluentd configuration like this:

    <match users>
      @type kaboom
      key user.favorite_movies
      add_tag_prefix exploded.
    </match>
 
 This will result in three new messages being emitted:
 
 1. `{"user": {"first_name": "John", "last_name": "Smith", "favorite_movies": "John Wick"}}`
 2. `{"user": {"first_name": "John", "last_name": "Smith", "favorite_movies": "Robocop"}}`
 3. `{"user": {"first_name": "John", "last_name": "Smith", "favorite_movies": "Blade Runner"}}`

Each new message will be tagged `exploded.users` adhering to the `add_tag_prefix` configuration value. This tag can then be matched on later enabling processing of the messages individually. To complete the use case mentioned earlier, they can be put into Redshift so that the userbase's favorite movies can be analyzed. 
