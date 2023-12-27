# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ActionSentinel
  class AccessPermissionGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    argument :model_name, type: :string, desc: "Name of the model to associate with AccessPermission"

    class_option :uuid, type: :boolean, default: false, desc: "Use UUID type as primary/foreign key"

    def self.next_migration_number(path)
      ActiveRecord::Generators::Base.next_migration_number(path)
    end

    def create_access_pemission_and_migration
      inject_action_permissible_into_model
      generate_access_permission
      generate_migration
    end

    private

    def generate_access_permission
      template "access_permission.rb", File.join("app", "models", "access_permission.rb")
    end

    def primary_key_type
      options.uuid? ? ", id: :uuid" : ""
    end

    def foreign_key_type
      options.uuid? ? ", type: :uuid" : ""
    end

    def generate_migration
      migration_template "migration.rb", "db/migrate/create_access_permissions.rb"
    end

    def model_class
      model_name.camelize
    end

    def singular_model_name
      model_name.underscore
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end

    def inject_action_permissible_into_model
      model_file = File.join("app", "models", "#{singular_model_name}.rb")
      inject_into_class(model_file, model_class) do
        "\taction_permissible\n"
      end
    end
  end
end
