require 'fluent/output'
require 'json'
require_relative 'TagUpdater'
require_relative 'KeysValidator'
require_relative 'RecordExploder'
require_relative 'ValuesRetriever'

module Fluent
  class Kaboom < Output

    Fluent::Plugin.register_output('kaboom', self)

    config_param :key, :string
    config_param :tag, :string, default: nil
    config_param :remove_tag_prefix, :string, default: nil
    config_param :add_tag_prefix, :string, default: nil

    def configure(conf)
      super

      @record_exploder = RecordExploder.new(ValuesRetriever.new)
      @tag_updater = TagUpdater.new
      @keys_validator = KeysValidator.new

      key_pattern = "^([^\\\"\\.]+\\.)*[^\\\"\.]+$"

      key_regex = Regexp.new(key_pattern)

      if (!@tag && !@add_tag_prefix && !@remove_tag_prefix)
        raise ConfigError, "One of tag, add_tag_prefix, or remove_tag_prefix must be set. remove_tag_prefix and add_tag_prefix may be used together."
      elsif (@tag && (@add_tag_prefix || @remove_tag_prefix))
        raise ConfigError, "tag can not be used in conjunction with add_tag_prefix or remove_tag_prefix; the former would override the latter."
      elsif (!@key.match(key_pattern))
        raise ConfigError, "key is malformed; it should consist of dot-separated field names like foo.bar.baz or \"f.oo\".bar.baz if part of your key contains dots."
      end
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      chain.next
      
      new_tag = tag
      if (@tag)
        new_tag = @tag
      else
        new_tag = @tag_updater.update_tag(tag, @remove_tag_prefix, @add_tag_prefix)
      end

      keys = key.split(".")

      es.each do |time,record|

        new_records = []

        if (@keys_validator.keys_are_valid?(keys, record) === false)
          new_records = [record]
        else
          new_records = @record_exploder.explode_record(keys, record)
        end
          
        new_records.each do |record|
          router.emit(new_tag, time, record)
        end
      end
    end
  end
end
