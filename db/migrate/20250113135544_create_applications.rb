class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.integer :amount
      t.string :sport
      t.integer :people_count
      t.integer :inactivity

      t.timestamps
    end
  end
end
