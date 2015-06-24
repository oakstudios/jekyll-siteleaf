require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require 'jekyll/siteleaf'

class MockSite
  # A Jekyll::Site to satisfy our tests
  attr_reader :config
  attr_accessor :posts, :frontmatter_defaults,
                :permalink_style, :converters

  def initialize(config)
    @config = config.clone
  end

  def show_drafts
    true
  end
end

class Minitest::Test
  def mock_site(_id: nil, config: {})
    MockSite.new(config.merge('_id' => _id))
  end
end
