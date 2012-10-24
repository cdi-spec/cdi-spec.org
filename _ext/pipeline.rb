
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/news', :posts ) 
  extension Awestruct::Extensions::Atomizer.new( :posts, '/news/news.atom' )

  # todo: Tagging
  
  # todo: We should probably do an extension for scraping JIRA
  #       We can do things like what BVAL is doing, but automattically
  #       based on versions, labels, etc. We'll need a rest client gem
  
  # todo: awestruct, as we're on a version of awestruct that I don't think
  #       has it built in we'll need our own version

  extension Awestruct::Extensions::Disqus.new
  helper Awestruct::Extensions::Partial
  helper Awestruct::Extensions::GoogleAnalytics

  extension Awestruct::Extensions::Indexifier.new
end

