class CreateSeals < ActiveRecord::Migration
  def change
    create_table :seals do |t|
      t.references :contract, index: true, foreign_key: true
      t.date :month
      t.boolean :sealed_flag
      t.date :sealed_date
      t.string :staff_nickname

      t.timestamps null: false
    end
  end
end
