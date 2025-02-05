class AddLatLongToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :lat, :float
    add_column :applications, :long, :float
  end
end
