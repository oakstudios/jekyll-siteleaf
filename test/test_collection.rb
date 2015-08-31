require 'helper'

class TestCollection < Minitest::Test
  attr_reader :site
  def setup
    @site = jekyll_site('_id' => 123)
  end

  def test_label
    got = Jekyll::Siteleaf::Collection.new site, collection(label: 'foobar')
    assert_equal 'foobar', got.label
  end

  def test_label__sanitization
    got = Jekyll::Siteleaf::Collection.new site, collection(label: '#foobar_-.1')
    assert_equal 'foobar_-.1', got.label
  end

  def test_metadata
    got = Jekyll::Siteleaf::Collection.new site,
      collection(metadata: { 'fizz' => 'buzz' })
    assert_equal({ 'fizz' => 'buzz' }, got.metadata)
  end

  def test_docs
    got = Jekyll::Siteleaf::Collection.new site,
      collection(docs: [
        document(content: 'Bar', path: 'some/path/bar.md', extname: '.md'),
        document(content: 'Foo', path: 'some/path/foo.md', extname: '.md')
      ])

    assert %w[foo bar], got.docs.map(&:path).map { |x| File.basename(x) }

    got.docs.each do |doc|
      assert doc.is_a?(Jekyll::Siteleaf::Document)
    end
  end
end
