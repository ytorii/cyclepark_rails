class ContractParamsSetup
  def before_save(contract)
    set_term_and_money_params(contract)
  end

  def before_create(contract)
    set_contract_params(contract)
    set_seals_params(contract)
  end

  def before_update(contract)
    set_canceledseals_params(contract)
  end

  def after_create(contract)
    update_leaf_lastdate(contract)
  end

  def after_destroy(contract)
    backdate_leaf_lastdate(contract)
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
    contract.new_flag = new_contract?(contract.leaf)
    contract.start_month = contract_start_month(contract.leaf)
  end

  # New contract starts with leaf's start date
  # Extended contract starts with next month of leaf's last date
  def contract_start_month(leaf)
    new_contract?(leaf) ? leaf_start_month(leaf) : next_month_of_last_contract(leaf)
  end

  #TODO: should move to leaf concern module
  def new_contract?(leaf)
    leaf.contracts.size.zero?
  end

  #TODO: should move to leaf concern module
  def leaf_start_month(leaf)
    leaf.start_date.beginning_of_month
  end

  #TODO: should move to leaf concern module
  def next_month_of_last_contract(leaf)
    leaf.last_date.next_month.beginning_of_month
  end

  # The leaf's last_date is contracts's last month
  def update_leaf_lastdate(contract)
    contract.leaf.update(last_date: end_of_contract_month(contract))
  end

  def set_seals_params(contract) 
    first_seal = contract.seals.first
    first_seal.month = contract_start_month(contract.leaf)
    set_seal_date_and_nickname(first_seal)
    set_rest_seals_params(contract)
  end

  def set_seal_date_and_nickname(seal)
    if seal.sealed_flag
      seal.sealed_date = seal.contract.contract_date
      seal.staff_nickname = seal.contract.staff_nickname
    else
      seal.sealed_date = seal.staff_nickname = nil
    end
  end

  # Setting rest seals parameters.
  # Excluding the first seal by starting index with 1.
  def set_rest_seals_params(contract)
    start_month = contract_start_month(contract.leaf)
    1.upto(contract.term1 + contract.term2 - 1) do |i|
      contract.seals.build(month: start_month + i.months, sealed_flag: false)
    end
  end
  
  # All cenceled seal should initialize date and nickname.
  def set_canceledseals_params(contract)
    contract.seals.select{|s| !s.sealed_flag}.each do |seal|
      seal.sealed_date = seal.staff_nickname = nil
    end
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
