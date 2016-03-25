module Lappen
  module Generators
    class PipelineGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(__dir__, 'templates'))

      def create_pipeline
        template 'pipeline.rb', File.join('app', 'pipelines', class_path, "#{file_name}_pipeline.rb")
      end

      private

      def subclass
        if application_pipeline_present?
          'ApplicationPipeline'
        else
          'Lappen::Pipeline'
        end
      end

      def application_pipeline_present?
        update_autoload_paths

        begin
          ::ApplicationPipeline
        rescue NameError
          false
        end
      end

      def update_autoload_paths
        if File.directory?(pipelines_path) && !autoload_paths.include?(pipelines_path)
          autoload_paths << pipelines_path
        end
      end

      def autoload_paths
        @autoload_paths ||= ActiveSupport::Dependencies.autoload_paths
      end

      def pipelines_path
        @pipelines_path ||= Rails.root.join('app', 'pipelines').to_s
      end
    end
  end
end
