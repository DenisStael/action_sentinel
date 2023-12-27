# frozen_string_literal: true

class ApplicationController
  include ActionSentinel::Authorization

  attr_reader :current_user, :action_name

  def initialize(current_user, action_name)
    @current_user = current_user
    @action_name = action_name
  end

  def self.controller_path
    @controller_path ||= name.demodulize.sub(/Controller$/, "").underscore
  end

  def controller_path
    self.class.controller_path
  end
end

class UsersController < ApplicationController
  def create
    authorize_action!

    "Created User"
  end
end
