require 'helper'

class TestReader < Minitest::Test
  attr_reader :reader
  def setup
    @reader = Jekyll::Reader.new mock_site(_id: 123)
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

    Jekyll::Siteleaf.post_reader.verify
    Jekyll::Siteleaf.draft_reader.verify
    Jekyll::Siteleaf.page_reader.verify
    Jekyll::Siteleaf.collection_reader.verify
  end
end
