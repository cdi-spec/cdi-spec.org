# a small reworking of the post extension to pull out the dates and archives
module Awestruct
  module Extensions
    class FAQ

      attr_accessor :path_prefix, :assign_to

      def initialize(path_prefix='', assign_to=:faq)
        @path_prefix      = path_prefix
        @assign_to        = assign_to
      end

      def execute(site)
        faq   = []

        site.pages.each do |page|
          if page.relative_source_path =~ /^#{@path_prefix}\//
            page.relative_source_path =~ /^#{@path_prefix}\/([0-9]*)(-?)(.*)\..*$/
            page.order ||= $1
            page.slug ||= $3
            context = page.create_context
            page.output_path = "#{@path_prefix}/#{page.slug}.html"
            faq << page
          end
        end

        faq.sort! { |a,b| b.order <=> a.order }

        last = nil
        singular = @assign_to.to_s.singularize
        faq.each do |e|
          if last != nil
            e.send( "next_#{singular}=", last )
            last.send( "previous_#{singular}=", e )
          end
          last = e
        end
        site.send( "#{@assign_to}=", faq )
      end
    end
  end
end
