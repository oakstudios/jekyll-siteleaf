lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jekyll/siteleaf/version'

Gem::Specification.new do |gem|
  gem.name          = 'jekyll-siteleaf'
  gem.version       = Jekyll::Siteleaf::VERSION
  gem.authors       = ['Larry Fox']
  gem.email         = ['larry@oakmade.com']
  gem.summary       = 'Jekyll Siteleaf bridge'

  gem.required_ruby_version = '>= 2.2'

  gem.add_dependency 'jekyll', '3.4.3'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'minitest', '~> 5.5.1'

  gem.files         += Dir.glob('lib/**/*.rb')
  gem.test_files    = Dir.glob('test/**/*')
  gem.require_paths = ['lib']
end
