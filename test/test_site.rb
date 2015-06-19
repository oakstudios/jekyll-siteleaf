require 'helper'
require 'jekyll/siteleaf/site'

class TestSite < Minitest::Test
  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
  end

  def test_id_returns__id
    assert_equal 123, site.id
  end
end
