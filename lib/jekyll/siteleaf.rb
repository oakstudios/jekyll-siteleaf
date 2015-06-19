require 'jekyll'
require 'jekyll/siteleaf/site'
require 'jekyll/siteleaf/post'
require 'jekyll/siteleaf/reader'

module Jekyll
  module Siteleaf
    class << self
      [
        :collection_reader,
        :data_reader,
        :draft_reader,
        :layout_reader,
        :page_reader,
        :post_reader,
        :static_file_reader
      ].each do |reader|
        attr_writer reader
        define_method reader do
          instance_variable_get("@#{reader}") || raise(NotImplementedError)
        end
      end
    end
  end

  class Reader
    prepend Jekyll::Siteleaf::Reader
  end

  class Post
    prepend Jekyll::Siteleaf::Post
  end
end
