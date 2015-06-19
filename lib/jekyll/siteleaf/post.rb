module Jekyll
  module Siteleaf
    module Post
      attr_reader :_post_hash

      def initialize(site, post_hash)
        @site = site
        @_post_hash = post_hash
        process(name)

        if data.key?('date')
          @date =
            Utils.parse_date data['date'].to_s,
              "Post '#{relative_path}' does not have a valid date in the YAML front matter."
        end

        Jekyll::Hooks.trigger self, :post_init
      end

      def data
        @data ||= _post_hash.fetch('data', {}).tap do |hash|
          hash.default_proc = proc do |_, key|
            site.frontmatter_defaults.find(relative_path, type, key)
          end
        end
      end

      def name
        @name ||= _post_hash.fetch('name')
      end

      def content
        @content ||= _post_hash.fetch('content', '')
      end

      def categories
        @categories ||= _post_hash.fetch('categories', [])
      end

      def tags
        @tags ||= _post_hash.fetch('tags', [])
      end

      def extracted_excerpt
        @extracted_excerpt ||= extract_excerpt
      end
    end
  end
end
