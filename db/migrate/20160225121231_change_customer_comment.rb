class ChangeCustomerComment < ActiveRecord::Migration
  def change
    change_column(:customers, :comment, :string, null: true)
  end
end
