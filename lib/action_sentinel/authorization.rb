# frozen_string_literal: true

module ActionSentinel
  # Authorization methods for controlling access to controller actions.
  module Authorization
    protected

    # Authorize the current user to access the controller action.
    #
    # @raise [UnauthorizedAction] if the user is not authorized.
    # @return [void]
    def authorize_action!
      return if action_user.has_permission_to?(action_name, controller_name)

      raise UnauthorizedAction, "Not allowed to access '#{action_name}' action in #{controller_name}_controller"
    end

    # Retrieve the user associated with the current action.
    #
    # This method expects a current_user method with the current authenticated user
    # to exist or should be overridden to reflect the current user
    #
    # @return [Object] The user associated with the current action.
    def action_user
      current_user
    end
  end
end
