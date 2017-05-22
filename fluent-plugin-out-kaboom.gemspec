Gem::Specification.new do |gem|
  gem.name = 'fluent-plugin-out-kaboom'
  gem.version = '0.1.0'
  gem.author = 'Nick Sabol'
  gem.email = 'nick.sabol@gimbal.com'
  gem.summary = 'A Fluentd output plugin for exploding JSON array elements'
  gem.description = <<-EOF
    Use this Fluentd output plugin if you are processing JSON messages containing arrays of values or objects
    and need those elements exploded such that there is one new message emitted per array element.
  EOF
  gem.files = ['lib/out_kaboom.rb']
  gem.licenses = ['GPL-3.0']
end
