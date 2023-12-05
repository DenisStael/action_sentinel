# frozen_string_literal: true

require "action_sentinel/version"
require "action_sentinel/railtie"
require "action_sentinel/authorization"
require "action_sentinel/permissible"

module ActionSentinel
  class UnauthorizedAction < StandardError; end

  def action_permissible
    include ActionSentinel::Permissible
  end
end
