require 'helper'

class TestPage < Minitest::Test
  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
  end

  def test_name
    page = Jekyll::Siteleaf::Page.new site, 'name' => 'my-page.html'
    assert_equal 'my-page.html', page.name
  end

  def test_initialize__process
    page = Jekyll::Siteleaf::Page.new site, 'name' => 'my-page.html'
    assert_equal 'my-page', page.basename
    assert_equal '.html', page.ext
  end

  def test_content__not_present
    page = Jekyll::Siteleaf::Page.new site, 'name' => 'my-page.html'
    assert_equal '', page.content
  end

  def test_content
    page = Jekyll::Siteleaf::Page.new site,
      'name' => 'my-page.html',
      'content' => 'Cool Story'
    assert_equal 'Cool Story', page.content
  end

  def test_dir__not_present
    page = Jekyll::Siteleaf::Page.new site, 'name' => 'my-page.html'
    assert_equal '', page.instance_variable_get(:@dir)
  end

  def test_dir
    page = Jekyll::Siteleaf::Page.new site,
      'name' => 'my-page.html',
      'dir' => '/directory/path'
    assert_equal '/directory/path', page.instance_variable_get(:@dir)
  end

  def test_data
    page = Jekyll::Siteleaf::Page.new site,
      'name' => 'my-page.html',
      'data' => { 'ping' => 'pong' }
    assert_equal({ 'ping' => 'pong' }, page.data)
  end

  def test_data__default_proc
    page = Jekyll::Siteleaf::Page.new site, 'name' => 'my-page.html'
    site.frontmatter_defaults = Minitest::Mock.new
    site.frontmatter_defaults.expect(:find, 'bar',
      [File.join('', page.name), page.type, 'foo'])

    assert_equal('bar', page.data['foo'])
    site.frontmatter_defaults.verify
  end
end
