# frozen_string_literal: true

require "rails/railtie"

module ActionSentinel
  class Railtie < Rails::Railtie # :nodoc:
    initializer "action_sentinel.initialize" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.extend ActionSentinel
      end
    end
  end
end
