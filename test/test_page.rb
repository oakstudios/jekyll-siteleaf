require 'helper'

class TestPage < Minitest::Test
  MockPage = Struct.new(:name, :content, :data, :source_dir)
  def page(name: '', content: '', data: {}, source_dir: '')
    MockPage.new(name, content, data, source_dir)
  end

  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
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

  def test_dir
    got = Jekyll::Siteleaf::Page.new site,
      page(name: 'my-page.html', source_dir: '/directory/path')
    assert_equal '/directory/path', got.instance_variable_get(:@dir)
  end

  def test_data
    got = Jekyll::Siteleaf::Page.new site,
      page(name: 'my-page.html', data: { 'ping' => 'pong' })
    assert_equal({ 'ping' => 'pong' }, got.data)
  end

  def test_data__default_proc
    got = Jekyll::Siteleaf::Page.new site, page(name: 'my-page.html')
    site.frontmatter_defaults = Minitest::Mock.new
    site.frontmatter_defaults.expect(:find, 'bar',
      [File.join('', got.name), got.type, 'foo'])

    assert_equal('bar', got.data['foo'])
    site.frontmatter_defaults.verify
  end
end
