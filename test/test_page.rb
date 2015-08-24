require 'helper'

class TestPage < Minitest::Test
  MockPage = Struct.new(:name, :content, :data, :source_dir)
  def page(name: '', content: '', data: {}, source_dir: '')
    MockPage.new(name, content, data, source_dir)
  end

  attr_reader :site
  def setup
    @site = jekyll_site(
      '_id' => 123,
      'defaults' => [{
        'scope' => { 'type' => 'pages' },
        'values' => { 'foo' => 'bar' }
      }]
    )
  end

  def test_name
    got = Jekyll::Siteleaf::Page.new site, page(name: 'my-page.html')
    assert_equal 'my-page.html', got.name
  end

  def test_initialize__process
    got = Jekyll::Siteleaf::Page.new site, page(name: 'my-page.html')
    assert_equal 'my-page', got.basename
    assert_equal '.html', got.ext
  end

  def test_content
    got = Jekyll::Siteleaf::Page.new site,
      page(name: 'my-page.html', content: 'Cool Story')
    assert_equal 'Cool Story', got.content
  end

  def test_data
    got = Jekyll::Siteleaf::Page.new site,
      page(name: 'my-page.html', data: { 'ping' => 'pong' })
    assert_equal({ 'ping' => 'pong' }, got.data)
  end

  def test_data__default_proc
    got = Jekyll::Siteleaf::Page.new site, page(name: 'my-page.html')
    assert_equal 'bar', got.data['foo']
  end

  def test_relative_path
    got = Jekyll::Siteleaf::Page.new site,
      page(name: 'my-page.html', source_dir: 'foobar')
    assert_equal 'foobar/my-page.html', got.relative_path
  end
end
