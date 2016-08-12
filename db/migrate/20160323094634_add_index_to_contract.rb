class AddIndexToContract < ActiveRecord::Migration
  def change
    add_index :contracts, [ :contract_date, :skip_flag ]
  end
end
