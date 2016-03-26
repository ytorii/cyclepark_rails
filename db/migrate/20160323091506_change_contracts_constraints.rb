class ChangeContractsConstraints < ActiveRecord::Migration
  def change
    change_column :contracts, :contract_date, :date, null: false
    change_column :contracts, :start_month, :date, null: false
    change_column :contracts, :term1, :integer, null: false
    change_column :contracts, :money1, :integer, null: false
    change_column :contracts, :term2, :integer, null: false
    change_column :contracts, :money2, :integer, null: false
    change_column :contracts, :new_flag, :boolean, null: false
    change_column :contracts, :skip_flag, :boolean, null: false
    change_column :contracts, :staff_nickname, :string, null: false
  end
end
