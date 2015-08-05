module Jekyll
  module Siteleaf
    class Site < SimpleDelegator
      def id
        config.fetch('_id')
      end

      def collections=(collections)
        __getobj__.instance_variable_set(:@collections, collections)
      end
    end
  end
end
