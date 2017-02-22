class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.integer :year
      t.integer :student_count
      t.boolean :fee_waiver
      t.boolean :consent
      t.string :stripe_card_token
      t.string :stripe_charge_token
      t.string :email
      t.string :confirmation_code
      t.integer :total
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
