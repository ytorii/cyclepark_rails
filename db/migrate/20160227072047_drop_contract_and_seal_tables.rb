class DropContractAndSealTables < ActiveRecord::Migration
  def change
    drop_table :contracts, :seals
  end
end
