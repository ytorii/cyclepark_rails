class ContractSetup
  def initialize(contract)
    @contract = contract
  end

  def before_save
    if @contract.skip_flag
      set_skip_contract_params
    else
      set_nonskip_contract_params
    end
  end
    
  private

  def set_nonskip_contract_params
    # Nil inputs are transformed to 0.
    @contract.term2 ||= 0
    @contract.money2 ||= 0
  end

  def set_skip_contract_params
    # Term1 is 1, terms2 and moneys are set to 0.
    @contract.term1 = 1
    @contract.term2 = 0
    @contract.money1 = 0
    @contract.money2 = 0
  end
end
