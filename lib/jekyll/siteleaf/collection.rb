module Jekyll
  module Siteleaf
    class Collection < Jekyll::Collection
      extend Forwardable
      attr_reader :_collection
      def_delegators :@_collection, :label, :metadata

      # TODO: Delegate files to @_collection

      def initialize(site, _collection)
        @site = site
        @_collection = _collection
      end

      def label
        @label ||= sanitize_label(_collection.label)
      end

      def docs
        @docs ||= _collection.docs.map do |doc|
          Jekyll::Siteleaf::Document.new(doc, site: site, collection: self)
        end
      end
    end
  end
end
