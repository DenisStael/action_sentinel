class CreateAccessPermissions < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :access_permissions<%= primary_key_type %> do |t|
      t.string :controller_path, null: false
      t.string :actions, null: false, array: true, default: []
      t.references :<%= singular_model_name %>, null: false<%= foreign_key_type %>

      t.timestamps
    end

    add_index :access_permissions, [:controller_path, :<%= singular_model_name %>_id], unique: true
  end
end
