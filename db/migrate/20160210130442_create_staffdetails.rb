class CreateStaffdetails < ActiveRecord::Migration
  def change
    create_table :staffdetails do |t|
      t.references :staff, index: true, foreign_key: true
      t.string :name, limit: 20, null: false
      t.string :read, limit: 20, null: false
      t.string :address, limit: 50, null: false
      t.date :birthday, null: false
      t.string :phone_number, limit: 12
      t.string :cell_number, limit: 13

      t.timestamps null: false
    end
  end
end
