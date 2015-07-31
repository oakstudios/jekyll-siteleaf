module Jekyll
  module Siteleaf
    class Page < Jekyll::Page
      # Page can be any file with YAML front matter

      def initialize(site, page_hash)
        @site    = site
        @name    = page_hash.fetch('name')
        @content = page_hash.fetch('content', '')
        @dir     = page_hash.fetch('dir', '')
        # NOTE: @dir and Page#dir are two different things in Jekyll :shrug:
        # BUT: Page#dir does depend on @dir via Page#url and Page#url_placeholders

        process  name
        set_data page_hash.fetch('data', {})

        Jekyll::Hooks.trigger self, :post_init
      end

      private

      def set_data(data)
        self.data = data.tap do |hash|
          hash.default_proc = proc do |_, key|
            site.frontmatter_defaults.find(File.join(@dir, name), type, key)
          end
        end
      end
    end
  end
end
