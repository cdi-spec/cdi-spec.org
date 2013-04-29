require 'asciidoctor'

# Public: A small extension to pull out information out of asciidoc files.
module Awestruct
  module Extensions
    class FAQ

      attr_accessor :path_prefix, :assign_to

      # Public: Basic constructor
      #
      # faq_dir - The name of the directory containing the faq files.
      # assign_to - Variable name to add these faqs to the site
      def initialize(faq_dir, assign_to=:faq)
        @faq_dir      = faq_dir
        @assign_to     = assign_to
      end

      # Internal: The workhorse method for the extension, called by awestruct.
      #
      # site - The awestruct site variable.
      #
      # Returns nothing.
      def execute(site)
        faq = []

        # Find all the asciidoc files
        faq_files = []
        Find.find(File.join(site.dir, @faq_dir)) do |path|
          faq_files << path if path =~ /.*\.asciidoc$/
        end

        faq_files.each do |file|
          doc = Asciidoctor.load(File.new(file, 'r'))
          faq << {:title => doc.doctitle, 
                  :order => (doc.attributes['order'] || '999999').to_i,
                  :since => doc.attributes['since'] || '1.0', 
                  :rendered_content => doc.render({:header_footer => false})
                 }
        end

        faq.sort! { |a,b| a[:order] <=> b[:order] }

        site.send( "#{@assign_to}=", faq )
      end

      # Internal: Method called by awestruct to add more directories to watch.
      # 
      # watched_dirs - A list of directories awestruct is watching.
      #
      # Returns nothing.
      def watch(watched_dirs)
        watched_dirs << @faq_dir
      end
    end
  end
end
