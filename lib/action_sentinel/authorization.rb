# frozen_string_literal: true

module ActionSentinel
  module Authorization
    protected

    def authorize_action!
      return if action_user.has_permission_to?(action_name, controller_name)

      raise UnauthorizedAction, "Not allowed to access '#{action_name}' action in #{controller_name}_controller"
    end

    def action_user
      current_user
    end
  end
end
