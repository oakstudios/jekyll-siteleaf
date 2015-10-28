module Jekyll
  module Siteleaf
    class Collection < Jekyll::Collection
      extend Forwardable
      attr_reader :_collection
      def_delegators :@_collection, :label, :metadata

      def initialize(site, _collection)
        @site = site
        @_collection = _collection
      end

      def label
        @label ||= sanitize_label(_collection.label)
      end

      def docs
        @docs ||= begin
          _collection.docs
            .map { |doc| Jekyll::Siteleaf::Document.new(doc, site: site, collection: self) }
            .select { |doc| site.publisher.publish?(doc) }
            .sort # Jekyll sorts docs after reading, we do it too
        end
      end

      def files
        @files ||= _collection.files.map do |file|
          Jekyll::Siteleaf::StaticFile.new(file, site: site, collection: self)
        end
      end
    end
  end
end
