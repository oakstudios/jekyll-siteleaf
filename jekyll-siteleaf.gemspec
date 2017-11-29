lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jekyll/siteleaf/version'

Gem::Specification.new do |gem|
  gem.name          = 'jekyll-siteleaf'
  gem.version       = Jekyll::Siteleaf::VERSION
  gem.authors       = ['Siteleaf']
  gem.email         = ['team@siteleaf.com']
  gem.summary       = 'Jekyll Siteleaf bridge'

  gem.required_ruby_version = '>= 2.2'

  gem.add_dependency 'jekyll', '3.6.2'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'minitest', '~> 5.8.4'

  gem.files         += Dir.glob('lib/**/*.rb')
  gem.test_files    = Dir.glob('test/**/*')
  gem.require_paths = ['lib']
end
