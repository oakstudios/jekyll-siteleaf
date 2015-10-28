require 'helper'

class TestReader < Minitest::Test
  attr_reader :reader, :site
  def setup
    source = File.expand_path('./source', File.dirname(__FILE__))
    @site = jekyll_site('source' => source, 'show_drafts' => true)
    @reader = Jekyll::Siteleaf::Reader.new site
  end

  def test_siteleaf_site
    assert_instance_of Jekyll::Siteleaf::Site, reader.site
  end

  MockCollection = Struct.new(:label, :docs)

  def test_read
    collection = MockCollection.new('foo', [])

    site.post_reader = Minitest::Mock.new
    site.post_reader.expect :call, [
      postable(name: '2015-06-15-foo-bar.md', data: { 'published' => false }),
      postable(name: '2015-06-15-example.md'),
      postable(name: '3000-06-15-a-long-long-time.md')
    ], [reader.site]
    site.draft_reader = Minitest::Mock.new
    site.draft_reader.expect :call, [
      postable(name: 'first-draft.md', data: { 'date' => Time.now }),
      postable(name: 'second-draft.md', data: { 'published' => false })
    ], [reader.site]
    site.page_reader = Minitest::Mock.new
    site.page_reader.expect :call, [
      page(name: 'foobar.md', data: { 'published' => false })
    ], [reader.site]
    site.collection_reader = Minitest::Mock.new
    site.collection_reader.expect :call, [collection], [reader.site]

    reader.read

    assert_equal %w[
      contacts/index.html
      css/screen.css
    ], site.static_files.map(&:relative_path)

    assert_equal %w[
      ./.htaccess
      contacts/bar.html
      css/main.scss
    ], site.pages.map(&:relative_path)

    assert_equal %w[
      _posts/2015-06-15-example.md
      _drafts/first-draft.md
    ], site.posts.map(&:relative_path)

    assert site.collections.key?('foo')

    site.post_reader.verify
    site.draft_reader.verify
    site.page_reader.verify
    site.collection_reader.verify
  end

  def test_static_files
    assert_equal %w[
      contacts/index.html
      css/screen.css
    ], reader.static_files
  end

  def test_page_static_files
    assert_equal %w[
      about.md
      contacts/bar.html
      css/main.scss
      .htaccess
    ], reader.yaml_static_files
  end
end
