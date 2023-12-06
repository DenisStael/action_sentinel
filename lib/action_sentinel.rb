# frozen_string_literal: true

require "action_sentinel/version"
require "action_sentinel/railtie"
require "action_sentinel/authorization"
require "action_sentinel/permissible"

# The ActionSentinel module provides a simple mechanism for user authorization
# within Rails applications, based on permissions in model-level.
module ActionSentinel
  #
  # Exception class raised when an unauthorized action is attempted.
  class UnauthorizedAction < StandardError; end

  # Includes the Permissible module in the calling model class
  # to manage permissions for controller actions.
  #
  # @example:
  #
  #   class User < ApplicationRecord
  #     action_permissible
  #   end
  #
  # @see ActionSentinel::Permissible
  def action_permissible
    include ActionSentinel::Permissible
  end
end
