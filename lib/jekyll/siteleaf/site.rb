module Jekyll
  module Siteleaf
    class Site < SimpleDelegator
      attr_accessor :collections

      def id
        config.fetch('_id')
      end
    end
  end
end
