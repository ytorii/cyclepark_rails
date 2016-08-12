class AddIndexToSeal < ActiveRecord::Migration
  def change
    add_index :seals, :month
  end
end
