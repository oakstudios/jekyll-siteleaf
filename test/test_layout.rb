require 'helper'

class TestLayout < Minitest::Test
  def store
    {
      '_layouts/page.md' => ['{{ page.body }}', { 'layout' => 'default' }],
    }
  end

  def setup
    @site = jekyll_site('source' => SOURCE, 'skip_config_files' => true)
    @site.reader = @reader = Jekyll::Siteleaf::Reader.new(@site, store)
    @layout = Jekyll::Siteleaf::Layout.new(@site, @site.config['layouts_dir'], 'page.md')
  end

  def test_read_with
    @layout.read_with(@reader)
    assert_equal '{{ page.body }}', @layout.content
    assert_equal 'default', @layout.data['layout']
  end

  def test_read_yaml
    @layout.read_yaml(nil, nil)
    assert_equal '{{ page.body }}', @layout.content
    assert_equal 'default', @layout.data['layout']
  end
end
