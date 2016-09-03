class AddComplexIndexToSeal < ActiveRecord::Migration
  def change
    add_index :seals, [:month, :sealed_flag] 
  end
end
