class AddIndexToLeaf < ActiveRecord::Migration
  def change
    add_index :leafs, [:number, :type, :valid_flag]
  end
end
