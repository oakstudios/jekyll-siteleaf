module Jekyll
  module Siteleaf
    module Collection

      # TODO: Pass documents/files via the collection_hash

      def initialize(site, collection_hash)
        @site     = site
        @label    = sanitize_label(collection_hash.fetch('label'))
        @metadata = collection_hash.fetch('metadata', {})
      end
    end
  end
end
