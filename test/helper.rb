require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require 'jekyll/siteleaf'

class MockSite
  # A Jekyll::Site to satisfy our tests
  attr_reader :config
  attr_accessor :posts, :frontmatter_defaults,
                :permalink_style, :converters,
                :pages, :collections

  def initialize(config)
    @config = config.clone
  end

  def show_drafts
    true
  end

  def in_source_dir(*args)
    source
  end
end

MockDocument = Struct.new(:content, :path, :extname, :data)
MockCollection = Struct.new(:label, :metadata, :docs)

class Minitest::Test
  def default_site_config(config = {})
    Jekyll::Configuration::DEFAULTS.merge(config)
  end

  def jekyll_site(config = {})
    Jekyll::Siteleaf::Site.new default_site_config(config)
  end

  def document(content: '', path: '', extname: '', data: {})
    MockDocument.new(content, path, extname, data)
  end

  def collection(label: '', metadata: {}, docs: [])
    MockCollection.new(label, metadata, docs)
  end
end
