# jekyll-siteleaf

A poorly documented series of monkey patches and refinements to Jekyll that removes the 
filesystem dependency from the Jekyll read process. There's really nothing specific to
[Siteleaf](http://v2.siteleaf.com) about it, but it does enable you to read from a database
for instance, which we find handy.


### Basic Usage

The main class is `Jekyll::Siteleaf::Reader` which is a drop in replacement for `Jekyll::Reader`. 

Initialize the new reader with a `Jekyll::Site` and a "store", which should be a hash like object 
that can respond to `#fetch` and `#keys`.

~~~ ruby
require 'jekyll/siteleaf'

jekyll_site = Jekyll::Site.new(Jekyll.configuration)
jekyll_site.reader = Jekyll::Siteleaf::Reader.new(jekyll_site, store)
~~~

If your store was a literal hash it would look like this:

~~~ ruby
store = {
  'index.md' => ['Welcome to my site', { 'title' => 'Home' }],
  'about.md' => ['This is what I’m about', { 'title' => 'About' }]
}
~~~

Where the key is a "filename" and the value is an array of content and frontmatter.
