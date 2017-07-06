# Set appropriate parameter to Contract model
class ContractsSetup
  def initialize(params={})
    @leaf = params[:leaf]
    @contract = params[:contract]
    @seals = @contract.seals

  end
  def set_parameter
    set_term_money_params
    set_newcontract_params
    set_month_seal_params
  end

  private
  def set_term_money_params
    if @contract.skip_flag
      set_skipcontract_params
    else
      set_contract_params
    end
  end

  def set_month_seal_params
    if @contract.new_record?
      # Seals needs to insert parameters before validation.
      # Because first seal parameters depend on inputs from web pages.
      set_newflag_startmonth_params
      set_seals_params
    else
      # Setting params for editing exist records,
      # especially in editing seal records.
      set_canceledseals_params
    end
  end

  def set_skipcontract_params
    # Term1 is 1, terms2 and moneys are set to 0.
    @contract.term1 = 1
    @contract.term2 = 0
    @contract.money1 = 0
    @contract.money2 = 0
  end

  def set_contract_params
    @contract.skip_flag = false
    # Nil inputs is transformed to 0.
    # term1 is not allowed with 0, so validation rejects after this
    @contract.term1 = term1.to_i
    @contract.term2 = term2.to_i
    @contract.money2 = money2.to_i
  end

  # New_flag and start_month should be determined automatically
  # by the model itself, not by inputs from web pages.
  def set_newflag_startmonth_params

    # New contract starts with leaf's start date
    if @leaf.contracts.size.zero?
      @contract.new_flag = true
      @contract.start_month = leaf.start_date.beginning_of_month
    # Extended contract starts with next month of leaf's last date
    else
      @contract.new_flag = false
      @contract.start_month = leaf.last_date.next_month.beginning_of_month
    end
  end

  def set_seals_params
    set_firstseal_params

    # Setting rest seals parameters.
    # Excluding the first seal by starting index with 1.
    1.upto(term1 + term2 - 1) do |i|
      @seals.build(month: start_month + i.months, sealed_flag: false)
    end
  end

  def set_firstseal_params
    first_seal = @seals.first
    first_seal.attributes = { month: start_month }

    # make nil sealed_flag false
    # if false, attributes below is left to nil.
    if first_seal.sealed_flag ||= false
      first_seal.attributes = {
        sealed_date: contract_date,
        staff_nickname: staff_nickname
      }
    end
  end

  # All cenceled seal should initialize date and nickname.
  def set_canceledseals_params
    @seals.each do |seal|
      unless seal.sealed_flag
        seal.sealed_date = nil
        seal.staff_nickname = nil
      end
    end
  end
end
