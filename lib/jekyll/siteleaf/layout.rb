# Layout is not a refinment because read_yaml is called
# within Page#initialize and is not refined in that context
module Jekyll
  module Siteleaf
    class Layout < Jekyll::Layout
      def read_yaml(_, _, _ = {})
        read_with(site.reader)
      end

      def read_with(reader)
        path = File.join(site.config['layouts_dir'], name)
        self.content, self.data = reader.store.fetch(path)
      end
    end
  end
end
