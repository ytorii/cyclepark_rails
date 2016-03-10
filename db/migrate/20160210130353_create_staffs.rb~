class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :nickname, limit: 10, null: false
      t.string :password, null: false
      t.boolean :admin_flag, default: false
  
      t.timestamps null: false
    end
  end
end
