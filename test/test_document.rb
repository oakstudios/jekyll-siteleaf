require 'helper'

class TestDocument < Minitest::Test
  using Jekyll::Siteleaf

  def store
    {
      '_foobar/about.md' => ['Document Content', { 'layout' => 'doc', 'author' => 'Jekyll & Hyde' }],
      '_posts/2015-11-15-first-post.md' => ['Post Content', { 'layout' => 'post' }]
    }
  end

  def setup
    @site = jekyll_site(
      'source' => SOURCE,
      'skip_config_files' => true,
      'collections' => %w[foobar],
      'defaults' => [
        {
          'scope' => {
            'path' => '',
            'type' => 'foobar'
          },
          'values' => {
            'a_default' => 'test'
          }
        }
      ]
    )
    @reader = Jekyll::Siteleaf::Reader.new(@site, store)
    @doc = Jekyll::Document.new(
      File.join(@site.source, '_foobar/about.md'),
      site: @site,
      collection: @site.collections['foobar']
    )
    @post = Jekyll::Document.new(
      File.join(@site.source, '_posts/2015-11-15-first-post.md'),
      site: @site,
      collection: @site.posts
    )
  end

  def test_read_with
    @doc.read_with(@reader)
    assert_equal 'Document Content', @doc.content
    assert_equal 'doc', @doc.data['layout']
    assert_equal 'Jekyll & Hyde', @doc.data['author']

    # Using merge to get the actual key/values that exist in `data`
    # and bypass the default_proc that Jekyll uses to lookup defaults
    assert_equal 'test', {}.merge(@doc.data)['a_default']
  end

  def test_read_with__post
    @post.read_with(@reader)
    assert_equal 'Post Content', @post.content
    assert_equal 'post', @post.data['layout']
    assert_equal Time.new(2015, 11, 15), @post.data['date']
    assert_equal 'first-post', @post.data['slug']
    assert_equal '.md', @post.data['ext']
  end
end
