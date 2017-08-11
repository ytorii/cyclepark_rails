class ContractParamsSetup 
  class << self
  include LeafUtilities

    def before_save(contract)
      set_term_and_money_params(contract)
    end

    def before_create(contract)
      set_contract_params(contract)
      SealParamsSetup.before_create(contract)
    end

    def before_update(contract)
      SealParamsSetup.before_update(contract)
    end

    private
    def set_term_and_money_params(contract)
      if contract.skip_flag
        set_skip_contract_params(contract)
      else
        set_nonskip_contract_params(contract)
      end
    end

    # Term1 is 1, terms2 and moneys are set to 0.
    def set_skip_contract_params(contract)
      contract.term1 = 1
      contract.term2 = contract.money1 = contract.money2 = 0
    end

    # Nil inputs are transformed to 0.
    def set_nonskip_contract_params(contract)
      contract.term2 ||= 0
      contract.money2 ||= 0
    end

    # New_flag and start_month should be determined automatically
    # by the model itself, not by inputs from web pages.
    def set_contract_params(contract)
      contract.new_flag = new_leaf?(contract.leaf)
      contract.start_month = contract_start_month(contract.leaf)
    end
  end
end
