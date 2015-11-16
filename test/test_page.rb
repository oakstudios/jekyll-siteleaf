require 'helper'

class TestPage < Minitest::Test
  def store
    {
      'foobar/about.md' => ['My Content', { 'layout' => 'page', 'author' => 'Jekyll & Hyde' }]
    }
  end

  def setup
    @site = jekyll_site('source' => SOURCE, 'skip_config_files' => true)
    @site.reader = @reader = Jekyll::Siteleaf::Reader.new(@site, store)
    @page = Jekyll::Siteleaf::Page.new(@site, @site.source, 'foobar', 'about.md')
  end

  def test_read_with
    @page.read_with(@reader)
    assert_equal 'My Content', @page.content
    assert_equal 'page', @page.data['layout']
    assert_equal 'Jekyll & Hyde', @page.data['author']
  end

  def test_read_yaml
    @page.read_yaml(nil, nil)
    assert_equal 'My Content', @page.content
    assert_equal 'page', @page.data['layout']
    assert_equal 'Jekyll & Hyde', @page.data['author']
  end
end
