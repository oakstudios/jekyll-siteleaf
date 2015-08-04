require 'helper'

class TestReader < Minitest::Test
  attr_reader :reader
  def setup
    source = File.expand_path('./source', File.dirname(__FILE__))
    @reader = Jekyll::Reader.new \
      jekyll_site('source' => source, 'show_drafts' => true)
  end

  def test_site
    assert_instance_of Jekyll::Siteleaf::Site, reader.site
  end

  def test_read
    Jekyll::Siteleaf.post_reader = Minitest::Mock.new
    Jekyll::Siteleaf.post_reader.expect :call, [], [reader.site]
    Jekyll::Siteleaf.draft_reader = Minitest::Mock.new
    Jekyll::Siteleaf.draft_reader.expect :call, [], [reader.site]
    Jekyll::Siteleaf.page_reader = Minitest::Mock.new
    Jekyll::Siteleaf.page_reader.expect :call, [], [reader.site]
    Jekyll::Siteleaf.collection_reader = Minitest::Mock.new
    Jekyll::Siteleaf.collection_reader.expect :call, [], [reader.site]

    reader.read

    assert_equal %w[
      /contacts/index.html
      /css/screen.css
    ], reader.site.static_files.map(&:relative_path)

    assert_equal %w[
      .htaccess
      contacts/bar.html
      css/main.scss
    ], reader.site.pages.map(&:name)

    Jekyll::Siteleaf.post_reader.verify
    Jekyll::Siteleaf.draft_reader.verify
    Jekyll::Siteleaf.page_reader.verify
    Jekyll::Siteleaf.collection_reader.verify
  end

  def test_static_files
    assert_equal %w[
      contacts/index.html
      css/screen.css
    ], reader.static_files
  end

  def test_page_static_files
    assert_equal %w[
      contacts/bar.html
      css/main.scss
      .htaccess
    ], reader.yaml_static_files
  end
end
