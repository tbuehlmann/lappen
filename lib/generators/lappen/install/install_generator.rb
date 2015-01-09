module Lappen
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_application_lappen
        template 'application_lappen.rb', 'app/lappens/application_lappen.rb'
      end
    end
  end
end
