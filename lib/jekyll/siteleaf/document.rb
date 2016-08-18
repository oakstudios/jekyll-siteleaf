module Jekyll
  module Siteleaf
    class Document < Jekyll::Document
      # Jekyll attempts to use File.mtime(path) which fails when file doesn't exist
      def source_file_mtime
        @source_file_mtime ||= site.time
      end
    end
  end
end
