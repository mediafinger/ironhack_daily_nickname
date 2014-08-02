class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :daily_nickname

      t.timestamps
    end
  end
end
