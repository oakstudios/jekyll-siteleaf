require 'helper'

class TestReader < Minitest::Test
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
    '.dotfiles/hidden' => ['',{}],
    '_my_collection/doc-b.md' => ['',{}],
    '_my_collection/doc-a.md' => ['',{}],
    '_static_collection/not-read.md' => ['',{}],
    '_layouts/page.md' => ['',{}]
  }.freeze

  def setup
    @site = jekyll_site(
      'source' => SOURCE,
      'skip_config_files' => true,
      'data_dir' => '_my_data',
      'collections' => %w[my_collection]
    )
    @site.reader = @reader = Jekyll::Siteleaf::Reader.new(@site, STORE)
  end

  def test_get_entries
    assert_equal %w[
      about/foo.md
      about/bar.md
    ], @reader.get_entries('', 'about')
  end

  link = '/foobar/post/derp/1232'.split('/post/')[1].split('/')[0]

  def test_read__layouts
    @reader.read
    assert_equal %w[default post page], @site.layouts.keys
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
      ./README
      css/screen.css
      static/file.html
    ], @site.static_files.map(&:relative_path)
  end

  def test_read__data
    @reader.read

    assert_equal [
      { "name" => "Jack", "age" => 27, "blog" => "http://example.com/jack" },
      { "name" => "John", "age" => 32, "blog" => "http://example.com/john" }
    ], @site.data['members']

    assert_equal %w[
      java
      ruby
    ], @site.data['languages']
  end

  def test_read__collection_docs
    @reader.read

    assert_equal %w[
      _my_collection/doc-a.md
      _my_collection/doc-b.md
    ], @site.collections['my_collection'].docs.map(&:relative_path)
  end

  def test_read__collection_files
    @reader.read

    assert_equal %w[
      _my_collection/static_file.txt
    ], @site.collections['my_collection'].files.map(&:relative_path)
  end
end
