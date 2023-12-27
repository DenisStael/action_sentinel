# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActionSentinel::Permissible do
  let(:user) { User.create(name: "User") }

  describe "#add_permissions_to" do
    it "adds permissions to the access_permissions association" do
      user.add_permissions_to(:create, :update, :users)
      permission = user.access_permissions.last

      expect(permission.controller_path).to eq("users")
      expect(permission.actions).to contain_exactly("create", "update")
    end
  end

  describe "#remove_permissions_to" do
    it "removes permissions from the access_permissions association" do
      user.add_permissions_to(:create, :update, :users)
      user.remove_permissions_to(:update, :users)

      permission = user.access_permissions.last
      expect(permission.actions).to contain_exactly("create")
    end
  end

  describe "#has_permission_to?" do
    context "when user has the specified permission" do
      it "returns true" do
        user.add_permissions_to(:create, :users)

        expect(user.has_permission_to?(:create, :users)).to be(true)
      end
    end

    context "when user has not the specified permission" do
      it "returns false" do
        user.add_permissions_to(:update, :users)

        expect(user.has_permission_to?(:create, :users)).to be(false)
      end
    end
  end
end
