class RemoveIndexFromSeal < ActiveRecord::Migration
  def change
    remove_index :seals, :month
  end
end
