module Jekyll
  module Siteleaf
    class Site < Jekyll::Site
      attr_writer :collections

      def id
        config.fetch('_id')
      end

      def reader
        @_reader ||= Jekyll::Siteleaf::Reader.new(self)
      end
    end
  end
end
