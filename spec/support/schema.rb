# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name, null: false
  end

  create_table :access_permissions do |t|
    t.string :controller_name, null: false
    t.string :actions, null: false
    t.references :user, null: false
  end

  add_index :access_permissions, %i[controller_name user_id], unique: true
end
