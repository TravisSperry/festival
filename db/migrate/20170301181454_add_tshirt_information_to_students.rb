class AddTshirtInformationToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :shirt, :boolean, default: false
    add_column :students, :size, :integer
  end
end
