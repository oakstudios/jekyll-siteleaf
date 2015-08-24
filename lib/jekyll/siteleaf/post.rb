module Jekyll
  module Siteleaf
    class Post < Jekyll::Post
      prepend Jekyll::Siteleaf::Postable

      def relative_path
        File.join('_posts'.freeze, @name)
      end
    end
  end
end
