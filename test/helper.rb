require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require 'jekyll/siteleaf'

SOURCE = File.expand_path('./source', File.dirname(__FILE__))

class Minitest::Test
  def jekyll_site(config = {})
    Jekyll::Site.new(Jekyll.configuration(config))
  end
end
