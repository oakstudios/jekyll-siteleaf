require 'helper'

class TestPost < Minitest::Test
  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
  end

  def test_initialize__process_name
    post = Jekyll::Siteleaf::Post.new site, 'name' => '2015-06-15-foo-bar.derp'
    assert_equal Time.parse('2015-06-15').localtime, post.date
    assert_equal 'foo-bar', post.slug
    assert_equal '.derp', post.ext
  end

  def test_date__from_data
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'data' => {'date' => '2015-06-20'}
    assert_equal Time.parse('2015-06-20').localtime, post.date
  end

  def test_name
    post = Jekyll::Siteleaf::Post.new site, 'name' => '2015-06-15-foo-bar.md'
    assert_equal '2015-06-15-foo-bar.md', post.name
  end

  def test_content
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'content' =>  'foo bar'
    assert_equal 'foo bar', post.content
  end

  def test_categories
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'data' => { 'categories' =>  %w[fizz bang] }
    assert_equal %w[fizz bang], post.categories
  end

  def test_tags
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'data' => { 'tags' => %w[cool trending] }
    assert_equal %w[cool trending], post.tags
  end

  def test_data
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'data' => { 'ping' => 'pong' }
    assert_equal({ 'ping' => 'pong' }, post.data)
  end

  def test_data__default_proc
    post = Jekyll::Siteleaf::Post.new site, 'name' => '2015-06-15-foo-bar.md'
    site.frontmatter_defaults = Minitest::Mock.new
    site.frontmatter_defaults.expect(:find, 'bar', [post.relative_path, post.type, 'foo'])

    assert_equal('bar', post.data['foo'])
    site.frontmatter_defaults.verify
  end

  def test_extracted_excerpt
    # Jekyll requires all of this extra crap for generating exceprts :shrug:
    site.permalink_style = :none
    site.converters = []
    post = Jekyll::Siteleaf::Post.new site,
      'name' => '2015-06-15-foo-bar.md',
      'content' => "foo\n\nbar",
      'data' => { 'excerpt_separator' => "\n\n", 'permalink' => 'derp.html' }
    assert_equal "foo\n\n", post.extracted_excerpt.to_s
  end
end
