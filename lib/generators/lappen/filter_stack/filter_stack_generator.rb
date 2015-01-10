module Lappen
  module Generators
    class FilterStackGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_filter_stack
        template 'filter_stack.rb', File.join('app/filter_stacks', class_path, "#{file_name}_filter_stack.rb")
      end

      private

      def subclass
        ::ApplicationFilterStack
        'ApplicationFilterStack'
      rescue NameError
      	'Lappen::FilterStack'
      end
    end
  end
end
