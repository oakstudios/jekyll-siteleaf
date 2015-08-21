module Jekyll
  module Siteleaf
    class Reader < Jekyll::Reader
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
          site.post_reader
              .call(site)
              .map { |x| Jekyll::Siteleaf::Post.new(site, x) }
      end

      def retrieve_drafts
        site.posts +=
          site.draft_reader
              .call(site)
              .map { |x| Jekyll::Siteleaf::Draft.new(site, x) }
      end

      def retrieve_pages
        site.pages =
          site.page_reader
              .call(site)
              .map { |x| Jekyll::Siteleaf::Page.new(site, x) }

        # Include static files with yaml frontmatter
        site.pages +=
          yaml_static_files.map do |path|
            page = Jekyll::Page.new site,
              site.source,
              File.dirname(path),
              File.basename(path)
            page if site.publisher.publish?(page)
          end.compact
      end

      def retrieve_static_files
        # Files that don't have YAML frontmatter
        site.static_files =
          static_files.map do |path|
            StaticFile.new site,
              site.source,
              File.dirname(path),
              File.basename(path)
          end
      end

      def retrieve_data
        site.data = DataReader.new(site).read(site.config['data_source'])
      end

      def retrieve_collections
        site.collections =
          site.collection_reader
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
