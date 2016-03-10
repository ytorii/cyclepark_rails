class RenameColumnLeaf < ActiveRecord::Migration
  def change
    rename_column :leafs, :type, :vhiecle_type
  end
end
