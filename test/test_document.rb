require 'helper'

class TestDocument < Minitest::Test
  attr_reader :jekyll_document
  def setup
    site = jekyll_site(
      '_id' => 123,
      'source' => '/tmp/dir',
      'defaults' => [{
        'scope' => { 'path' => '' },
        'values' => { 'layout' => 'foobar' }
      }]
    )
    col = Jekyll::Siteleaf::Collection.new site,
      collection(label: 'foo', docs: [
        document(content: 'ABC', path: '_foo/abc.md', extname: '.md', data: { 'fizz' => 'bazz' })
      ])
    @jekyll_document = col.docs.first
  end

  def test_delegators
    assert_equal 'ABC', jekyll_document.content
    assert_equal '/tmp/dir/_foo/abc.md', jekyll_document.path
    assert_equal '.md', jekyll_document.extname
  end

  def test_data
    assert_equal jekyll_document.data['fizz'], 'bazz'
    assert_equal jekyll_document.data['layout'], 'foobar'
  end
end
