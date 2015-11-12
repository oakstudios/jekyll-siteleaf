module Jekyll
  module Siteleaf
    class Reader
      using Siteleaf # Enable refinements

      attr_reader :site, :store, :keys

      def initialize(site, store)
        @site = site
        @store = store
        @keys = store.keys
      end

      def read
        site.layouts = LayoutReader.new(site).read
        site.posts.docs.concat(read_posts)
        site.posts.docs.concat(read_drafts) if site.show_drafts
        site.pages.concat(read_pages)
        site.static_files.concat(read_static_files)
      end

      # For Jekyll compatablitiy
      def get_entries(base, dir)
        base.empty? && base = nil
        path = File.join(*[base, dir].compact).sub(/\/?\z/, '/'.freeze)
        filtered_keys.select { |key| key.start_with?(path) }
      end

      private

      def filtered_keys
        @filtered_keys ||= EntryFilter.new(site, nil).path_filter(keys)
      end

      def filtered_entries(entries)
        Jekyll::EntryFilter.new(site, nil).path_filter(entries)
      end

      def read_posts
        read_publishable('_posts', Document::DATE_FILENAME_MATCHER)
      end

      def read_drafts
        read_publishable('_drafts', Document::DATELESS_FILENAME_MATCHER)
      end

      def read_publishable(dir, matcher)
        keys.select { |x| x =~ %r{(\A|/)#{dir}/} }
          .each_with_object([]) do |path, acc|
            next unless path =~ matcher
            doc = Document.new(site.in_source_dir(path), site: site, collection: site.posts)
            doc.read_with(self)
            acc << doc if site.publisher.publish?(doc)
          end
      end

      def read_pages
        filtered_keys.each_with_object([]) do |path, acc|
          page = Page.new(*_args(path))
          acc << page if site.publisher.publish?(page)
        end
      end

      def read_static_files
        Dir.chdir(site.in_source_dir) do
          files = Dir.glob('**/{*,.*}').reject { |f| File.directory?(f) }
          filtered_entries(files).map do |path|
            StaticFile.new(*_args(path))
          end
        end
      end

      def _args(path)
        [site, site.source, File.dirname(path), File.basename(path)]
      end
    end
  end
end