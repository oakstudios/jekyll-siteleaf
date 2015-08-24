require 'helper'
require_relative 'test_postable'

class TestDraft < Minitest::Test
  include TestPostable

  def subject
    Jekyll::Siteleaf::Draft
  end

  def site_defaults
    [{
      'scope' => { 'type' => 'drafts' },
      'values' => { 'foo' => 'bar' }
    }]
  end

  def test_relative_path
    got = subject.new site, postable(name: 'foo-bar.md')
    assert_equal '_drafts/foo-bar.md', got.relative_path
  end

  def test_initialize__process_name
    got = subject.new site, postable(name: 'foo-bar.derp')
    assert_equal 'foo-bar', got.slug
    assert_equal '.derp', got.ext
  end
end
