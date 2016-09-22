class RemoveDeviceIdFromReservation < ActiveRecord::Migration
  def change
    remove_column :reservations, :device_id, :integer
  end
end
