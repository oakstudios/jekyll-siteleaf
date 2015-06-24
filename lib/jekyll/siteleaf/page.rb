module Jekyll
  module Siteleaf
    module Page
      # Page can be any file with YAML front matter
      attr_reader :_page_hash

      def initialize(site, page_hash)
        @site = site
        @_page_hash = page_hash

        # NOTE: @dir and #dir are two different things in Jekyll :shrug:
        # BUT: #dir does depend on @dir via #url and #url_placeholders
        @dir = _page_hash.fetch('dir', '')

        process(name)
        Jekyll::Hooks.trigger self, :post_init
      end

      def data
        @data ||= _page_hash.fetch('data', {}).tap do |hash|
          hash.default_proc = proc do |_, key|
            site.frontmatter_defaults.find(File.join(@dir, name), type, key)
          end
        end
      end

      def name
        @name ||= _page_hash.fetch('name')
      end

      def content
        @content ||=_page_hash.fetch('content', '')
      end
    end
  end
end
