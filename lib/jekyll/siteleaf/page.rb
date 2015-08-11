module Jekyll
  module Siteleaf
    class Page < Jekyll::Page
      # Page can be any file with YAML front matter
      extend Forwardable
      attr_reader :_page
      def_delegators :@_page, :name, :source_dir

      def initialize(site, _page)
        @site = site
        @_page = _page

        # NOTE: The instance variable @dir and method dir are two different
        # things in Jekyll :shrug: So we have to set it here.
        # BUT: Page#dir does depend on @dir via Page#url and Page#url_placeholders
        @dir = source_dir

        process name

        data.default_proc = proc do |_, key|
          site.frontmatter_defaults.find(File.join(@dir, name), type, key)
        end

        Jekyll::Hooks.trigger self, :post_init
      end

      def data
        @data ||= @_page.data.dup
      end

      def content
        @content ||= @_page.content.dup
      end
    end
  end
end
