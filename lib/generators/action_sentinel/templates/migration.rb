class CreateAccessPermissions < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :access_permissions<%= table_id_type %> do |t|
      t.string :controller_name, null: false
      t.string :actions, null: false, array: true, default: []
      t.references :<%= singular_model_name %>, null: false<%= table_id_type %>

      t.timestamps
    end

    add_index :access_permissions, [:controller_name, :<%= singular_model_name %>_id], unique: true
  end
end
