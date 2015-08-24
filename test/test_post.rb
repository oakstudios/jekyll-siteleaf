require 'helper'
require_relative 'test_postable'

class TestPost < Minitest::Test
  include TestPostable

  def subject
    Jekyll::Siteleaf::Post
  end

  def site_defaults
    [{
      'scope' => { 'type' => 'posts' },
      'values' => { 'foo' => 'bar' }
    }]
  end

  def test_initialize__process_name
    got = subject.new site, postable(name: '2015-06-15-foo-bar.derp')
    assert_equal Time.parse('2015-06-15').localtime, got.date
    assert_equal 'foo-bar', got.slug
    assert_equal '.derp', got.ext
  end

  def test_relative_path
    got = subject.new site, postable(name: '2015-06-15-foo-bar.md')
    assert_equal '_posts/2015-06-15-foo-bar.md', got.relative_path
  end
end
