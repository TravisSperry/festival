class AddCommentsToRegistration < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :comments, :text
  end
end
