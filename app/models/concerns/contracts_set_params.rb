require 'active_support'

# Modules for Contract model
module ContractsSetParams
  extend ActiveSupport::Concern

  def set_contract_params
    set_newflag_startmonth_params
  end

  def set_skipcontract_params
    # Term1 is 1, terms2 and moneys are set to 0.
    self.term1 = 1
    self.term2 = 0
    self.money1 = 0
    self.money2 = 0
  end

  def set_nilcontract_params
    self.skip_flag = false
    # Nil inputs is transformed to 0.
    # term1 is not allowed with 0, so validation rejects after this
    self.term1 = term1.to_i
    self.term2 = term2.to_i
    self.money2 = money2.to_i
  end

  # New_flag and start_month should be determined automatically
  # by the model itself, not by inputs from web pages.
  def set_newflag_startmonth_params
    leaf = Leaf.find(leaf_id)

    # New contract starts with leaf's start date
    if leaf.contracts.size.zero?
      self.new_flag = true
      self.start_month = leaf.start_date.beginning_of_month
    # Extended contract starts with next month of leaf's last date
    else
      self.new_flag = false
      self.start_month = leaf.last_date.next_month.beginning_of_month
    end
  end

  def set_seals_params
    set_firstseal_params

    # Setting rest seals parameters.
    # Excluding the first seal by starting index with 1.
    1.upto(term1 + term2 - 1) do |i|
      seals.build(month: start_month + i.months, sealed_flag: false)
    end
  end

  def set_firstseal_params
    first_seal = seals.first
    first_seal.attributes = { month: start_month }

    # make nil sealed_flag false
    # if false, attributes below is left to nil.
    if first_seal.sealed_flag ||= false
      first_seal.attributes = {
        sealed_date: contract_date,
        staff_nickname: session[:staff_nickname]
      }
    end
  end

  # All cenceled seal should initialize date and nickname.
  def set_canceledseals_params
    seals.each do |seal|
      unless seal.sealed_flag
        seal.sealed_date = nil
        seal.staff_nickname = nil
      end
    end
  end

  # The leaf's last_date is contracts's last month
  def update_leaf_lastdate
    Leaf.find(leaf_id).update_attribute(:last_date, seals.last.month)
  end

  # Leaf's last_date should be backdated after the last contract deleted.
  def backdate_leaf_lastdate
    last_contract = self.leaf.contracts.last
    #last_contract = Leaf.find(self.leaf_id).contracts.last

    # No contract when self itself is the last contract of the leaf. 
    if last_contract.nil? || last_contract  == self
      self.leaf.update(last_date: nil)
    else
      self.leaf.update(last_date: last_contract.seals.last.month)
    end
  end
end
