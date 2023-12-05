# frozen_string_literal: true

require "active_support/concern"

module ActionSentinel
  module Permissible
    extend ActiveSupport::Concern

    included do
      has_many :access_permissions
    end

    def add_permissions_to(*actions, controller_name)
      permission = access_permissions.find_or_initialize_by(controller_name: controller_name)
      permission.assign_attributes(actions: (permission.actions + sanitize_actions_array(actions)).uniq)
      permission.save
    end

    def remove_permissions_to(*actions, controller_name)
      permission = access_permissions.find_by(controller_name: controller_name)
      permission&.update(actions: (permission.actions - sanitize_actions_array(actions)))
    end

    # rubocop:disable Naming/PredicateName
    def has_permission_to?(action, controller_name)
      access_permissions
        .where(controller_name: controller_name)
        .where(':action = ANY("access_permissions"."actions")', action: action)
        .exists?
    end
    # rubocop:enable Naming/PredicateName

    private

    def sanitize_actions_array(actions)
      actions.map { |action| action.to_s unless action.blank? }.compact
    end
  end
end
