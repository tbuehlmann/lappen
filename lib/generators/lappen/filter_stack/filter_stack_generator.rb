module Lappen
  module Generators
    class FilterStackGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(__dir__, 'templates'))

      def create_filter_stack
        template 'filter_stack.rb', File.join('app', 'filter_stacks', class_path, "#{file_name}_filter_stack.rb")
      end

      private

      def subclass
        if application_filter_stack_present?
          'ApplicationFilterStack'
        else
          'Lappen::FilterStack'
        end
      end

      def application_filter_stack_present?
        update_autoload_paths!

        begin
          ::ApplicationFilterStack
        rescue NameError
          false
        end
      end

      def update_autoload_paths!
        if File.directory?(filter_stacks_path) && !autoload_paths.include?(filter_stacks_path)
          autoload_paths << filter_stacks_path
        end
      end

      def autoload_paths
        @autoload_paths ||= ActiveSupport::Dependencies.autoload_paths
      end

      def filter_stacks_path
        @filter_stacks_path ||= Rails.root.join('app', 'filter_stacks').to_s
      end
    end
  end
end
