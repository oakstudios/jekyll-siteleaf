module Jekyll
  module Siteleaf
    refine Document do
      def read_with(reader)
        @to_liquid = nil
        Jekyll.logger.debug "Reading:", relative_path

        self.content, data = reader.store.fetch(relative_path)
        merge_data!(data)
        post_read
      end
    end
  end
end
