module Lappen
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_application_filter_stack
        template 'application_filter_stack.rb', 'app/filter_stacks/application_filter_stack.rb'
      end
    end
  end
end
