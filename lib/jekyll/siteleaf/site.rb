module Jekyll
  module Siteleaf
    class Site < SimpleDelegator
      def id
        config.fetch('_id')
      end
    end
  end
end
