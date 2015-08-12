require 'helper'

class TestDocument < Minitest::Test
  MockDocument = Struct.new(:content, :path, :extname, :data)
  def document(content: '', path: '', extname: '', data: {})
    MockDocument.new(content, path, extname, data)
  end

  def test_delegators
    doc = document(
      content: 'Foo bar',
      path: 'some/path/foobar.md',
      extname: '.md',
      data: { foo: :bar }
    )

    jekyll_doc = Jekyll::Siteleaf::Document.new(doc,
      site: jekyll_site('source' => '/tmp/dir'),
      collection: nil
    )

    assert_equal 'Foo bar', jekyll_doc.content
    assert_equal '/tmp/dir/some/path/foobar.md', jekyll_doc.path
    assert_equal '.md', jekyll_doc.extname
    assert_equal({ foo: :bar }, jekyll_doc.data)
  end
end
