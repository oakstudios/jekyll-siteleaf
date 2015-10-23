require 'helper'

class TestStaticFile < Minitest::Test

  def mock_static_file
    @mock_static_file ||= MockStaticFile.new('test/foobar.txt')
  end

  def subject
    Jekyll::Siteleaf::StaticFile.new(
      mock_static_file,
      site: jekyll_site('source' => '/source/dir')
    )
  end

  def test_relative_path
    assert_equal 'test/foobar.txt', subject.relative_path
  end

  def test_extname
    assert_equal '.txt', subject.extname
  end

  def test_dir
    assert_equal 'test', subject.instance_variable_get('@dir')
  end

  def test_name
    assert_equal 'foobar.txt', subject.instance_variable_get('@name')
  end

  def test__static_file
    assert_equal mock_static_file, subject.instance_variable_get('@_static_file')
  end

  def test_path
    assert_equal '/source/dir/test/foobar.txt', subject.path
  end
end
