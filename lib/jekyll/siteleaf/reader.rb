module Jekyll
  module Siteleaf
    module Reader
      def site
        @_site ||= Jekyll::Siteleaf::Site.new(@site)
      end

      def read
        retrieve_layouts
        retrieve_posts
        retrieve_drafts if site.show_drafts
        retrieve_pages
        retrieve_static_files
        sort_files!
        retrieve_data
        retrieve_collections
      end

      private

      def sort_files!
        # TODO: Remove this once retrieve_pages is implemented
        # We can probably just rely on Jekyll::Reader#sort_files!
      end

      def retrieve_layouts
        # TODO
        # Any assets that are in the layouts directory specified
        # in `site.config['layouts']`
        # Also needs to satisfy Jekyll::EntryFilter
      end

      def retrieve_posts
        site.posts =
          Siteleaf.post_reader
                  .call(site)
                  .map { |x| Jekyll::Post.new(site, x) }
      end

      def retrieve_drafts
        site.posts +=
          Siteleaf.draft_reader
                  .call(site)
                  .map { |x| Jekyll::Draft.new(site, x) }
      end

      def retrieve_pages
        # page_reader should also include Siteleaf Assets that have YAML frontmatter
        site.pages +=
          Siteleaf.page_reader
                  .call(site)
                  .map { |x| Jekyll::Page.new(site, x) }
      end

      def retrieve_static_files
        # TODO
        # Siteleaf Assets that don't have YAML frontmatter
      end

      def retrieve_data
        # TODO
        # Any .{csv,yml,json} assets that are in the data directroy
        # specified in `site.config['data_source']`
      end

      def retrieve_collections
        site.collections +=
          Siteleaf.collection_reader
                  .call(site)
                  .map { |x| Jekyll::Collection.new(site, x) }
      end
    end
  end
end
