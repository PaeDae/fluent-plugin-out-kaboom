require 'fluent/output'
require 'json'

module Fluent
  class SomeOutput < Output

    Fluent::Plugin.register_output('kaboom', self)

    config_param :key, :string
    config_param :tag, :string, default: nil
    config_param :remove_tag_prefix, :string, default: nil
    config_param :add_tag_prefix, :string, default: nil

    def configure(conf)
      super

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
        if (@remove_tag_prefix && tag.start_with?(@remove_tag_prefix))
          new_tag = new_tag.sub(@remove_tag_prefix, "")
        end

        if (@add_tag_prefix)
          new_tag = "#{@add_tag_prefix}#{new_tag}"
        end
      end

      es.each {|time,record|

        keys = @key.split(".")

        upper_record = record

        if (keys.length > 1)
          keys[0..keys.length - 2].each {|key|
            if (!upper_record.key?(key))
              router.emit(new_tag, time, record)
              return
            end

            upper_record = upper_record[key]
          }
        end

        if (!upper_record.key?(keys.last))
          router.emit(new_tag, time, record)
          return
        end

        upper_record[keys.last].each {|item|
          upper_record[keys.last] = item
          router.emit(new_tag, time, record)
        }
      }
    end
  end
end
