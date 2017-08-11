class LeafLastDateUpdator
  class << self
    def after_create(contract)
      update_leaf_lastdate(contract)
    end

    def after_destroy(contract)
      backdate_leaf_lastdate(contract)
    end

    private
    def update_leaf_lastdate(contract)
      contract.leaf.update(last_date: end_of_contract_month(contract))
    end

    def end_of_contract_month(contract)
      contract.seals.last.month.end_of_month
    end

    def backdate_leaf_lastdate(contract)
      # No contract when self itself is the last contract of the leaf. 
      if contract.leaf.contracts.size > 1
        contract.leaf.update(last_date: end_of_previous_month(contract))
      else
        contract.leaf.update(last_date: nil)
      end
    end

    def end_of_previous_month(contract)
      contract.start_month.last_month.end_of_month
    end
  end
end
