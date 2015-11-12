module Jekyll
  module Siteleaf
    refine EntryFilter do
      def path_filter(entries)
        entries.reject do |entry|
          unless included?(entry)
            entry.split('/').any? do |e|
              special?(e) || backup?(e) || excluded?(e) || symlink?(e)
            end
          end
        end
      end
    end
  end
end
