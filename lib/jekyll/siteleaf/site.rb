module Jekyll
  module Siteleaf
    class Site < Jekyll::Site
      attr_writer :collections

      attr_accessor :post_reader, :page_reader,
                    :draft_reader, :collection_reader

      def id
        config.fetch('_id')
      end

      def reader
        @_reader ||= Jekyll::Siteleaf::Reader.new(self)
      end
    end
  end
end
