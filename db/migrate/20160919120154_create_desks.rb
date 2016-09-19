class CreateDesks < ActiveRecord::Migration
  def change
    create_table :desks do |t|
      t.string :name
      t.text :point
      t.integer :seats
      t.integer :screen
      t.boolean :visiolync
      t.integer :zone_id
      t.integer :typo_place_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
