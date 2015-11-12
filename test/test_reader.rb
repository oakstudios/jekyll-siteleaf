require 'helper'

class TestReader < Minitest::Test
  SOURCE =  File.expand_path('./source', File.dirname(__FILE__))

  STORE = {
    '_posts/2015-06-15-example.md' => ['',{}],
    'category/_posts/2015-06-16-category.md' => ['',{}],
    '_posts/2015-06-15-hidden.md' => ['',{ 'published' => false }],
    '_posts/3000-06-15-future.md' => ['',{}],
    '_drafts/draft.md' => ['',{}],
    'category/_drafts/cat-draft.md' => ['',{}],
    '_drafts/draft-hidden.md' => ['',{ 'published' => false }],
    '.htaccess' => ['',{}],
    'about.md' => ['',{}],
    'about/foo.md' => ['',{}],
    'about/bar.md' => ['',{ 'published' => false }],
    'about/_ignored.md' => ['',{}],
    'about/_ignored/file.md' => ['',{}],
    '.dotfiles/hidden' => ['',{}]
  }.freeze

  def jekyll_site(config = {})
    Jekyll::Site.new(Jekyll.configuration(config))
  end

  def setup
    @site = jekyll_site(
      'source' => SOURCE, 
      'skip_config_files' => true
    )
    @site.reader = @reader = Jekyll::Siteleaf::Reader.new(@site, STORE)
  end

  def test_get_entries
    assert_equal %w[
      about/foo.md
      about/bar.md
    ], @reader.get_entries('', 'about')
  end

  def test_read__layouts
    @reader.read
    assert_equal %w[default post], @site.layouts.keys
  end

  def test_read__posts
    @reader.read
    assert_equal %w[
      _posts/2015-06-15-example.md
      category/_posts/2015-06-16-category.md
    ], @site.posts.docs.map(&:relative_path)
  end

  def test_read__posts__future
    @site.future = true
    @reader.read

    assert_equal %w[
      _posts/2015-06-15-example.md
      category/_posts/2015-06-16-category.md
      _posts/3000-06-15-future.md
    ], @site.posts.docs.map(&:relative_path)
  end

  def test_read__posts__drafts
    @site.show_drafts = true
    @reader.read

    assert_equal %w[
      _posts/2015-06-15-example.md
      category/_posts/2015-06-16-category.md
      _drafts/draft.md
      category/_drafts/cat-draft.md
    ], @site.posts.docs.map(&:relative_path)
  end
  
  def test_read__pages
    @reader.read

    assert_equal %w[
      ./.htaccess
      ./about.md
      about/foo.md
    ], @site.pages.map(&:relative_path)
  end
  
  def test_read__static_files
    @reader.read

    assert_equal %w[
      css/screen.css
      ./README
      static/file.html
    ], @site.static_files.map(&:relative_path)
  end
end
