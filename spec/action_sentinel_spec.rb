# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActionSentinel do
  describe "#action_permissible" do
    it "includes Permissible module in the calling class" do
      expect(User.included_modules).to include(ActionSentinel::Permissible)
    end
  end
end
