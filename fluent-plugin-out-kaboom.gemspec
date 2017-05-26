Gem::Specification.new do |gem|
  gem.name = "fluent-plugin-out-kaboom"
  gem.version = "0.1.0"
  gem.author = "Nick Sabol"
  gem.email = "nick.sabol@gimbal.com"
  gem.summary = "A Fluentd output plugin for exploding JSON array elements"
  gem.homepage = "https://github.com/PaeDae/fluent-plugin-out-kaboom"
  gem.description = <<-EOF
    Use this Fluentd output plugin if you are processing JSON messages containing arrays of values or objects
    and need those elements exploded such that there is one new message emitted per array element.
  EOF
  gem.license = "GPL-3.0"

  gem.files = `git ls-files -z`
                .split("\x0")
                .reject { |f| f.match(%r{^(test|spec|features)/}) }

  gem.add_runtime_dependency 'fluentd', '~> 0.12'

  gem.add_development_dependency "test-unit", "~> 3.0"
  gem.add_development_dependency "rspec-mocks", "~> 3.6"
end
