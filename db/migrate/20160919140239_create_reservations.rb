class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :desk_id
      t.text :description
      t.date :reservation_date
      t.boolean :reservation_pm
      t.boolean :reservation_am

      t.timestamps null: false
    end
  end
end
