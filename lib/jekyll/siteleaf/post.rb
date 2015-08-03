module Jekyll
  module Siteleaf
    class Post < Jekyll::Post
      extend Forwardable
      attr_reader :_post
      def_delegators :@_post, :name, :content, :data

      def initialize(site, _post)
        @site = site
        @_post = _post

        process name

        data.default_proc = proc do |_, key|
          site.frontmatter_defaults.find(relative_path, type, key)
        end

        Jekyll::Hooks.trigger self, :post_init
      end

      def extracted_excerpt
        @extracted_excerpt ||= extract_excerpt
      end

      def tags
        @tags ||= data.fetch('tags', [])
      end

      def categories
        @categories ||= data.fetch('categories', [])
      end

      def date
        @_date ||= begin
          if data.key?('date')
            Utils.parse_date data['date'].to_s,
              "Post '#{relative_path}' does not have a valid date in the YAML front matter."
          else
            super
          end
        end
      end
    end
  end
end
