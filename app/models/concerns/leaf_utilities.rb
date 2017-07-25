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

  # New contract starts with leaf's start date
  # Extended contract starts with next month of leaf's last date
  def contract_start_month(leaf)
    new_leaf?(leaf) ?
      leaf_start_month(leaf) : next_month_of_leaf_last_contract(leaf)
  end
end
