class CreateNickname < ActiveRecord::Migration
  def change
    remove_column :users, :daily_nickname

    create_table :nicknames do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end
  end
end
