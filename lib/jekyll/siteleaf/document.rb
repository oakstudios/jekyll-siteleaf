module Jekyll
  module Siteleaf
    class Document < Jekyll::Document
      extend Forwardable
      attr_reader :_document
      def_delegators :@_document, :content, :path, :extname, :data

      def initialize(document, site:, collection:)
        @_document = document
        @site = site
        @collection = collection
      end

      def output_ext
        @output_ext ||= Jekyll::Renderer.new(site, self).output_ext
      end
    end
  end
end
