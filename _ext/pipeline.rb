require 'bootstrap-sass'
require File.join File.dirname(__FILE__), 'tweakruby'
require_relative 'restclient_extensions_enabler'
require_relative 'common' 
# require_relative 'jira'
require_relative 'faq'
require 'awestruct/extensions/minify'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::RestClientExtensions::EnableGetCache.new
  extension Awestruct::Extensions::RestClientExtensions::EnableJsonConverter.new
  extension Awestruct::Extensions::DataDir.new
  extension Awestruct::Extensions::Posts.new( '/news')
  extension Awestruct::Extensions::Paginator.new( :posts, '/news/index', :per_page=>5 )
  extension Awestruct::Extensions::TagCloud.new( :posts, '/news/tags/index.html', :layout=>'base' )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/news.atom', :num_entries=>20 )
 
  
  extension Awestruct::Extensions::FAQ.new( '_faq', :faq ) 
  # extension Awestruct::Extensions::Atomizer.new( :news, '/news/feed.atom' )

  # It would be really cool to combine these, will need to look into it.
  extension Awestruct::Extensions::Tagger.new( :faq, '/faq', '/faq/tags', :per_page=>10)
  # TODO: TagCloud

 # Awestruct::Extensions::Jira::Project.new(self, 'CDI:12311062')
    
  # todo: asciidoc, as we're on a version of asciidoc that I don't think
  #       has it built in we'll need our own version

  extension Awestruct::Extensions::Disqus.new
  helper Awestruct::Extensions::Partial
  helper Awestruct::Extensions::GoogleAnalytics

  extension Awestruct::Extensions::Indexifier.new
  extension Awestruct::Extensions::Sitemap.new
  extension Awestruct::Extensions::Tagger.new( :posts, '/news/index', '/news/tags', :per_page=>5)
  transformer Awestruct::Extensions::Minify.new
end

