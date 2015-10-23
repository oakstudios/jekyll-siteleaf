module Jekyll
  module Siteleaf
    class StaticFile < Jekyll::StaticFile
      attr_reader :_static_file

      # Pretty much verbatim from Jekyll's initialize with
      # tweaked function arguments
      def initialize(static_file, site:, collection: nil)
        @_static_file = static_file
        @site = site
        @base = site.source
        @dir  = File.dirname(static_file.filename)
        @name = File.basename(static_file.filename)
        @collection = collection
        @relative_path = static_file.filename
        @extname = File.extname(static_file.filename)
      end
    end
  end
end
