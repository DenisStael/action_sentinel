# frozen_string_literal: true

require "spec_helper"
require "support/controllers"

RSpec.describe ActionSentinel::Authorization do
  let(:user) { User.create(name: "User") }
  let(:controller) { UsersController.new(user, "create") }

  describe "authorize_action!" do
    context "when user does not have permission" do
      it "raises UnauthorizedAction error" do
        expect { controller.create }.to raise_error(ActionSentinel::UnauthorizedAction)
      end
    end

    context "when user has permission" do
      it "allows access to the action" do
        user.add_permissions_to :create, :users

        expect(controller.create).to eq("Created User")
      end
    end
  end

  describe "action_user" do
    it "returns the current_user" do
      controller.send(:action_user) == user
    end
  end
end
