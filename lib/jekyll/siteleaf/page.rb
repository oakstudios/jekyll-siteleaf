# Page is not a refinment because read_yaml is called
# within Page#initialize and is not refined in that context
module Jekyll
  module Siteleaf
    class Page < Jekyll::Page
      def read_yaml(_, _, _ = {})
        read_with(site.reader)
      end

      def read_with(reader)
        Jekyll.logger.debug "Reading:", relative_path

        # Some page paths start with `./`
        # While valid on disk, we're not using filenames like that
        self.content, self.data =
          reader.store.fetch(relative_path.sub(/\A\.\//, ''))
      end
    end
  end
end
