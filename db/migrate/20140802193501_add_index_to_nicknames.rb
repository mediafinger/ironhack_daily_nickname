class AddIndexToNicknames < ActiveRecord::Migration
  def change
    add_index :nicknames, [:user_id, :name], name: "index_nicknames_on_user_id_and_name", unique: true
  end
end
