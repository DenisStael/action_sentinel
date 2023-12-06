# frozen_string_literal: true

require "active_support/concern"

module ActionSentinel
  # Provides methods for managing access permissions associated with a model.
  #
  # This module is designed to be included in models that need to manage access permissions.
  # It introduces methods for adding, removing, and checking permissions associated with a specific
  # controller and actions.
  #
  # @example Including Permissible in a Model
  #   class User < ApplicationRecord
  #     include ActionSentinel::Permissible
  #   end
  #
  #   user = User.new
  #   user.add_permissions_to(:create, :update, :users)
  #   user.has_permission_to?(:create, :users) # => true
  #
  module Permissible
    extend ActiveSupport::Concern

    included do
      has_many :access_permissions
    end

    # Add permissions to the access_permissions association for a specific controller.
    #
    # @param actions [Array<Symbol, String>] The actions to add permissions for.
    # @param controller_name [String] The name of the controller.
    # @return [Boolean] true if the permission was saved, false otherwise.
    def add_permissions_to(*actions, controller_name)
      permission = access_permissions.find_or_initialize_by(controller_name: controller_name)
      permission.assign_attributes(actions: (permission.actions + sanitize_actions_array(actions)).uniq)
      permission.save
    end

    # Remove permissions from the access_permissions association for a specific controller.
    #
    # @param actions [Array<Symbol, String>] The actions to remove permissions for.
    # @param controller_name [String] The name of the controller.
    # @return [Boolean, nil] true if the permission was saved, false if it was not or nil
    #   if the permission was not found.
    def remove_permissions_to(*actions, controller_name)
      permission = access_permissions.find_by(controller_name: controller_name)
      permission&.update(actions: (permission.actions - sanitize_actions_array(actions)))
    end

    # rubocop:disable Naming/PredicateName

    # Check if the model has permission to perform a specific action in a controller.
    #
    # @param action [Symbol, String] The action to check permission for.
    # @param controller_name [String] The name of the controller.
    # @return [Boolean] true if the model has permission, false otherwise.
    def has_permission_to?(action, controller_name)
      query = access_permissions.where(controller_name: controller_name)

      query = if %w[sqlite sqlite3].include? self.class.connection.adapter_name.downcase
                query.where("actions LIKE ?", "%#{action}%")
              else
                query.where(':action = ANY("access_permissions"."actions")', action: action)
              end

      query.exists?
    end
    # rubocop:enable Naming/PredicateName

    private

    # Sanitize an array of actions by converting them to strings and removing blanks.
    #
    # @param actions [Array<Symbol, String>] The actions to sanitize.
    # @return [Array<String>] The sanitized actions.
    def sanitize_actions_array(actions)
      actions.map { |action| action.to_s unless action.blank? }.compact
    end
  end
end
