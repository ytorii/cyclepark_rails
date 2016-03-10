class AddColumnToLeafs < ActiveRecord::Migration
  def change
    add_column :leafs, :contracts_count, :integer
  end
end
