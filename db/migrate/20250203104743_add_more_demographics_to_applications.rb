class AddMoreDemographicsToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :low_income, :integer
    add_column :applications, :children, :integer
    add_column :applications, :lgbtq, :integer
    add_column :applications, :older, :integer
  end
end
