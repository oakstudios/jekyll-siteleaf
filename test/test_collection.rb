require 'helper'

class TestCollection < Minitest::Test
  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
  end

  def test_label
    collection = Jekyll::Collection.new site, 'label' => 'foobar'
    assert_equal 'foobar', collection.label
  end

  def test_label__sanitization
    collection = Jekyll::Collection.new site, 'label' => '#foobar_-.1'
    assert_equal 'foobar_-.1', collection.label
  end

  def test_metadata
    collection = Jekyll::Collection.new site,
      'label' => 'foobar',
      'metadata' => { 'fizz' => 'buzz' }
    assert_equal({ 'fizz' => 'buzz' }, collection.metadata)
  end

  def test_metadata__default
    collection = Jekyll::Collection.new site,
      'label' => 'foobar'
    assert_equal({}, collection.metadata)
  end
end
