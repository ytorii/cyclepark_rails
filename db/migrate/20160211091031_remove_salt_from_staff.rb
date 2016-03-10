class RemoveSaltFromStaff < ActiveRecord::Migration
  def change
    remove_column :staffs, :salt, :string
  end
end
