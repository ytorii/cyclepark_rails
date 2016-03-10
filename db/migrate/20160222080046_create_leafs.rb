class CreateLeafs < ActiveRecord::Migration
  def change
    create_table :leafs do |t|
      t.integer :number, limit: 4, null: false
      t.integer :type, limit: 1, null: false
      t.boolean :student_flag, null: false
      t.boolean :largebike_flag, null: false
      t.boolean :valid_flag, null: false
      t.date :start_date, null: false
      t.date :last_date

      t.timestamps null: false
    end
  end
end
