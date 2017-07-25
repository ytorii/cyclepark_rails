class SealParamsSetup 
  include LeafUtilities

  def initialize(contract)
    @contract = contract
  end

  def before_create
    set_seals_params(@contract)
  end

  def before_update
    set_canceledseals_params(@contract)
  end
    
  private
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
end
