class RemoveCustomerCommentDefault < ActiveRecord::Migration
  def change
    change_column_default(:customers, :comment, nil)
    change_column_default(:customers, :receipt, '不要')
  end
end
