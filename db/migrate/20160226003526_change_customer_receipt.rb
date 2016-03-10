class ChangeCustomerReceipt < ActiveRecord::Migration
  def change
    change_column(:customers, :receipt, :string, null: false)
  end
end
