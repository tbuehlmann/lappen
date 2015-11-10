module Lappen
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(__dir__, 'templates'))

      def copy_application_pipeline
        template 'application_pipeline.rb', 'app/pipelines/application_pipeline.rb'
      end
    end
  end
end
