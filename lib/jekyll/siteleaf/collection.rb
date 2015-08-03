module Jekyll
  module Siteleaf
    class Collection < Jekyll::Collection
      extend Forwardable
      attr_reader :_collection
      def_delegators :@_collection, :label, :metadata, :docs

      # TODO: Delegate files to @_collection

      def initialize(site, _collection)
        @site = site
        @_collection = _collection
      end

      def label
        @label ||= sanitize_label(_collection.label)
      end
    end
  end
end
