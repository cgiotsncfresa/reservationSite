class AddDeviceIdColumnToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :device_id, :integer
  end
end
