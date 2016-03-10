class AddSaltToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :salt, :string, limit: 20, null: false, default: 0
  end
end
