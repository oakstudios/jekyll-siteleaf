module Jekyll
  module Siteleaf
    module Post

      def initialize(site, post_hash)
        @site    = site
        @name    = post_hash.fetch('name')
        @content = post_hash.fetch('content', '')
        @tags    = post_hash.fetch('tags', [])
        @categories = post_hash.fetch('categories', [])

        process  name
        set_data post_hash.fetch('data', {})
        set_date data['date'] if data.key?('date')

        Jekyll::Hooks.trigger self, :post_init
      end

      def extracted_excerpt
        @extracted_excerpt ||= extract_excerpt
      end

      private

      def set_data(data)
        self.data = data.tap do |hash|
          hash.default_proc = proc do |_, key|
            site.frontmatter_defaults.find(relative_path, type, key)
          end
        end
      end

      def set_date(date)
        self.date = Utils.parse_date date.to_s,
          "Post '#{relative_path}' does not have a valid date in the YAML front matter."
      end
    end
  end
end
