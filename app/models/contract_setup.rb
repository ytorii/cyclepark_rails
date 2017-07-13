class ContractSetup
  def initialize(contract, leaf)
    @contract = contract
    @leaf = leaf
  end

  def before_save
    set_term_and_money_params
  end

  def before_create
    set_contract_params
    set_seals_params
  end

  def before_update
    set_canceledseals_params
  end

  def after_create
    update_leaf_lastdate(@contract)
  end

  def after_destroy
    # Leaf's last_date should be backdated after the last contract deleted.
    backdate_leaf_lastdate
  end
    
  private
  def set_term_and_money_params
    if @contract.skip_flag
      set_skip_contract_params
    else
      set_nonskip_contract_params
    end
  end

  # Term1 is 1, terms2 and moneys are set to 0.
  def set_skip_contract_params
    @contract.term1 = 1
    @contract.term2 = @contract.money1 = @contract.money2 = 0
  end

  # Nil inputs are transformed to 0.
  def set_nonskip_contract_params
    @contract.term2 ||= 0
    @contract.money2 ||= 0
  end

  # New_flag and start_month should be determined automatically
  # by the model itself, not by inputs from web pages.
  def set_contract_params
    @contract.new_flag = new_contract?
    @contract.start_month = contract_start_month
  end

  # New contract starts with leaf's start date
  # Extended contract starts with next month of leaf's last date
  def contract_start_month
    new_contract? ? leaf_start_month : next_month_of_last_contract
  end

  #TODO: should move to leaf concern module
  def new_contract?
    @leaf.contracts.size.zero?
  end

  #TODO: should move to leaf concern module
  def leaf_start_month
    @leaf.start_date.beginning_of_month
  end

  #TODO: should move to leaf concern module
  def next_month_of_last_contract
    @leaf.last_date.next_month.beginning_of_month
  end

  # The leaf's last_date is contracts's last month
  def update_leaf_lastdate(contract)
    @leaf.update(last_date: end_of_contract(contract))
  end

  def set_seals_params 
    set_first_seals_params(@contract.seals.first)
    set_rest_seals_params(@contract.seals)
  end

  def set_first_seals_params(first_seal)
    first_seal.month = contract_start_month
    if first_seal.sealed_flag
      first_seal.sealed_date = @contract.contract_date
      first_seal.staff_nickname = @contract.staff_nickname
    else
      first_seal.sealed_date = first_seal.staff_nickname = nil
    end
  end

  # Setting rest seals parameters.
  # Excluding the first seal by starting index with 1.
  def set_rest_seals_params(seals)
    start_month = contract_start_month
    1.upto(@contract.term1 + @contract.term2 - 1) do |i|
      seals.build(month: start_month + i.months, sealed_flag: false)
    end
  end
  
  # All cenceled seal should initialize date and nickname.
  def set_canceledseals_params
    @contract.seals.select{|s| !s.sealed_flag}.each do |seal|
      seal.sealed_date = seal.staff_nickname = nil
    end
  end

  def end_of_contract(contract)
    contract.seals.last.month.end_of_month
  end

  def backdate_leaf_lastdate
    # No contract when self itself is the last contract of the leaf. 
    if @leaf.contracts.size.zero?
      @leaf.update(last_date: nil)
    else
      update_leaf_lastdate(@leaf.contracts.last)
    end
  end

  def update_leaf_lastdate(contract)
    @leaf.update_attribute(:last_date, end_of_contract(contract))
  end
end
