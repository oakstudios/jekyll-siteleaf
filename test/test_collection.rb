require 'helper'

class TestCollection < Minitest::Test
  MockCollection = Struct.new(:label, :metadata, :docs)
  def collection(label: '', metadata: {}, docs: [])
    MockCollection.new(label, metadata, docs)
  end

  attr_reader :site
  def setup
    @site = Jekyll::Siteleaf::Site.new mock_site(_id: 123)
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
    # Just assert the delegation. Delegatees responsibility to return Document types.
    got = Jekyll::Siteleaf::Collection.new site,
      collection(docs: [
        { 'writing' => 'prose' },
        { 'anything' => 'goes' }
      ])
    assert_equal [
      { 'writing' => 'prose' },
      { 'anything' => 'goes' }
    ], got.docs
  end
end
