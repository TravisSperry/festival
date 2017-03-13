class AddSourceToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :source, :string, default: ""
    add_column :registrations, :source_other, :string, default: ""
  end
end
