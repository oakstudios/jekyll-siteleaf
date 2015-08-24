module TestPostable
  MockPostable = Struct.new(:name, :content, :data)
  def postable(name: '', content: '', data: {})
    MockPostable.new(name, content, data)
  end

  attr_reader :site
  def setup
    @site = jekyll_site(
      '_id' => 123,
      'defaults' => site_defaults
    )
  end

  def test_date__from_data
    got = subject.new site,
      postable(name: '2015-06-15-foo-bar.derp', data: { 'date' => '2015-06-20' })
    assert_equal Time.parse('2015-06-20').localtime, got.date
  end

  def test_name
    got = subject.new site, postable(name: '2015-06-15-foo-bar.md')
    assert_equal '2015-06-15-foo-bar.md', got.name
  end

  def test_content
    got = subject.new site,
      postable(name: '2015-06-15-foo-bar.md', content: 'foo bar')
    assert_equal 'foo bar', got.content
  end

  def test_categories
    got = subject.new site,
      postable(name: '2015-06-15-foo-bar.md', data: { 'categories' =>  %w[fizz bang] })
    assert_equal %w[fizz bang], got.categories
  end

  def test_tags
    got = subject.new site,
      postable(name: '2015-06-15-foo-bar.md', data: { 'tags' => %w[cool trending] })
    assert_equal %w[cool trending], got.tags
  end

  def test_data
    got = subject.new site,
      postable(name: '2015-06-15-foo-bar.md', data: { 'ping' => 'pong' })
    assert_equal({ 'ping' => 'pong' }, got.data)
  end

  def test_data__default_proc
    got = subject.new site, postable(name: '2015-06-15-foo-bar.md')
    assert_equal('bar', got.data['foo'])
  end

  def test_extracted_excerpt
    # Jekyll requires all of this extra crap for generating exceprts :shrug:
    site.permalink_style = :none
    site.converters = []
    got = subject.new site, postable(
      name: '2015-06-15-foo-bar.md',
      content: "foo\n\nbar",
      data: { 'excerpt_separator' => "\n\n", 'permalink' => 'derp.html' }
    )
    assert_equal "foo\n\n", got.extracted_excerpt.to_s
  end
end
