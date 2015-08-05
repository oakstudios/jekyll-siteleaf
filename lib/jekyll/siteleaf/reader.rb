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

      def static_files
        @static_files || parse_source_files.last
      end

      def yaml_static_files
        @yaml_static_files || parse_source_files.first
      end

      private

      def retrieve_layouts
        site.layouts = LayoutReader.new(site).read
      end

      def retrieve_posts
        site.posts =
          Siteleaf.post_reader
                  .call(site)
                  .map { |x| Jekyll::Siteleaf::Post.new(site, x) }
      end

      def retrieve_drafts
        site.posts +=
          Siteleaf.draft_reader
                  .call(site)
                  .map { |x| Jekyll::Siteleaf::Draft.new(site, x) }
      end

      def retrieve_pages
        site.pages =
          Siteleaf.page_reader
                  .call(site)
                  .map { |x| Jekyll::Siteleaf::Page.new(site, x) }

        # Include static files with yaml frontmatter
        site.pages += PageReader.new(site, '').read(yaml_static_files)
      end

      def retrieve_static_files
        # Files that don't have YAML frontmatter
        site.static_files =
          StaticFileReader.new(site, '').read(static_files)
      end

      def retrieve_data
        site.data = DataReader.new(site).read(site.config['data_source'])
      end

      def retrieve_collections
        site.collections =
          Siteleaf.collection_reader
                  .call(site)
                  .map { |x| Jekyll::Siteleaf::Collection.new(site, x) }
                  .each_with_object({}) { |c, h| h[c.label] = c }
      end

      def parse_source_files
        Dir.chdir(site.in_source_dir) do
          files = Dir.glob('**/{*,.*}').reject { |f| File.directory?(f) }
          @yaml_static_files, @static_files =
            filter_entries(files).partition do |file|
              Utils.has_yaml_header?(file)
            end
        end
      end
    end
  end
end
