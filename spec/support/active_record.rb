# frozen_string_literal: true

require "active_record"
require "action_sentinel"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.extend ActionSentinel

load "#{File.dirname(__FILE__)}/schema.rb"

class User < ActiveRecord::Base
  action_permissible
end

class AccessPermission < ActiveRecord::Base
  belongs_to :user

  validates :controller_name, uniqueness: { scope: :user_id }

  # The lines below are to sqlite database only
  serialize :actions

  after_initialize do |access_permission|
    access_permission.actions = [] if access_permission.actions.nil?
  end
end
