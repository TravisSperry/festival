class AddSchooNameToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :school_name, :string
  end
end
