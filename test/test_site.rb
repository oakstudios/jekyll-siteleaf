require 'helper'

class TestSite < Minitest::Test
  attr_reader :site
  def setup
    @site = jekyll_site('_id' => 123)
  end

  def test_id_returns__id
    assert_equal 123, site.id
  end

  def test_collections=
    assert site.respond_to? :collections=
  end

  def test_reader
    assert_instance_of Jekyll::Siteleaf::Reader, site.reader
  end
end
