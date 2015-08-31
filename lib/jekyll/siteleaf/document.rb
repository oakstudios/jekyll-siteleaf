module Jekyll
  module Siteleaf
    class Document < Jekyll::Document
      extend Forwardable
      attr_reader :_document
      def_delegators :@_document, :content, :extname

      def initialize(document, site:, collection:)
        @_document = document
        @site = site
        @collection = collection

        @data = Utils.deep_merge_hashes(
          site.frontmatter_defaults.all(url, collection.label.to_sym),
          _document.data
        )
      end

      def output_ext
        @output_ext ||= Jekyll::Renderer.new(site, self).output_ext
      end

      def path
        File.join(site.source, _document.path)
      end
    end
  end
end
