require 'active_support'
module LeafUtilities
  def new_leaf?(leaf)
    leaf.contracts.size.zero?
  end

  def leaf_start_month(leaf)
    leaf.start_date.beginning_of_month
  end

  def next_month_of_leaf_last_contract(leaf)
    leaf.last_date.next_month.beginning_of_month
  end
end
