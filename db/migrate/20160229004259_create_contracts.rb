class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :leaf, index: true, foreign_key: true
      t.date :contract_date
      t.date :start_month
      t.integer :term1
      t.integer :money1
      t.integer :term2
      t.integer :money2
      t.boolean :new_flag
      t.boolean :skip_flag
      t.string :staff_nickname

      t.timestamps null: false
    end
  end
end
