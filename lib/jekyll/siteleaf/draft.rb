module Jekyll
  module Siteleaf
    class Draft < Jekyll::Draft
      prepend Jekyll::Siteleaf::Postable

      def process(name)
        m, slug, ext = *name.match(MATCHER)
        self.slug = slug
        self.ext = ext
      end

      def relative_path
        File.join('_drafts'.freeze, @name)
      end
    end
  end
end
