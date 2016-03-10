class DropSealsTable < ActiveRecord::Migration
  def change
    drop_table :seals
  end
end
