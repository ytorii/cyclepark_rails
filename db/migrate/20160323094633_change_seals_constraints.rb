class ChangeSealsConstraints < ActiveRecord::Migration
  def change
    change_column :seals, :month, :date, null:false
    change_column :seals, :sealed_flag, :boolean, null:false
  end
end
