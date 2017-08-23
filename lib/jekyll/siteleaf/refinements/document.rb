module Jekyll
  module Siteleaf
    refine Document do
      def read_with(reader)
        @to_liquid = nil
        Jekyll.logger.debug "Reading:", relative_path

        merge_defaults
        self.content, data = reader.store.fetch(relative_path)
        merge_data!(data)
        read_post_data
      end
    end
  end
end
