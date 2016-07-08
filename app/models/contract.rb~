class Contract < ActiveRecord::Base
  include StaffsExist

  belongs_to :leaf, counter_cache: true
  has_many :seals, dependent: :destroy
  accepts_nested_attributes_for :seals

  date_regexp = /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/

  validates :contract_date,
    presence: true,
    format: { with: date_regexp, allow_blank: true}
  validates :start_month,
    presence: true,
    format: { with: date_regexp, allow_blank: true}
  # Term1 must be longer than 0 because 0 length contract is not allowed.
  validates :term1,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validates :money1,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true  }
  validates :term2,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 10, allow_blank: true  }
  validates :money2,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true  }
  validates :new_flag,
    inclusion: {in: [true, false]}
  validates :skip_flag,
    inclusion: {in: [true, false]}
  validate :staffExists?
  validate :monthAlreadyExists?, on: :create
  validate :termsSameLength?, on: :update

  before_validation do
    # Change nil inputs to 0.
    setSkipAndNilParams

    # Setting params are needed only when create new records
    if self.new_record?
      setContractParams
      setFirstSealParams
      #setRestSealsParams
    # Setting params for correcting existing records,
    # especially in correcting seal records.
    else
      setCanceledSealsParams
    end
  end

  # Except first seal record, all seal records parameters are
  # automatically set, so no needs to be validated.
  before_create do
    setRestSealsParams if self.new_record?
    updateLeafLastdate
  end

  before_destroy :isLastContract?
  after_destroy :backdateLeafLastdate

  private
  def setSkipAndNilParams
    # The skipped contracts has only one term and no money.
    if self.skip_flag
      self.term1 = 1
      self.term2 = 0
      self.money1 = 0
      self.money2 = 0
    else
      # The skip_flag should be false if the input value is nil.
      self.skip_flag = false

      # Nil inputs is transformed to 0.
      # term1 is not allowed with 0, so validation rejects after this
      self.term1 = self.term1.to_i
      self.term2 = self.term2.to_i
      self.money2 = self.money2.to_i
    end
  end

  # New_flag and start_month should be determined automatically
  # by the model itself, not by inputs from web pages.
  def setContractParams
    leaf = Leaf.find(self.leaf_id)

    # New contract starts with leaf's start date
    if (leaf.contracts.size == 0)
      self.new_flag = true
      self.start_month = leaf.start_date.beginning_of_month
    # Extended contract starts with next month of leaf's last date
    else
      self.new_flag = false
      self.start_month = leaf.last_date.next_month.beginning_of_month
    end
  end

  # First Seal needs to insert parameters before validation.
  # Because its parameters depend on inputs from web pages.
  def setFirstSealParams
    first_seal = self.seals.first
    
    # make nil sealed_flag false
    if (first_seal.sealed_flag ||= false)
      first_seal.attributes = {
        month: self.start_month,
        sealed_date: self.contract_date,
        staff_nickname: self.staff_nickname
      }
    else
      first_seal.attributes = {
        month: self.start_month,
        sealed_date: nil,
        staff_nickname: nil 
      }
    end
  end

  # The rest of Seals should be inserted parameters after validation.
  def setRestSealsParams
    month = self.start_month

    # Sub 1 time because the first seal record is already build
    (self.term1 + self.term2 - 1).times do |term|
      month = month.next_month
      self.seals.build(month: month, sealed_flag: false)
    end
  end

  # All canceled Seal should initialize date and nickname.
  def setCanceledSealsParams
    self.seals.each do |seal|
      unless seal.sealed_flag
        seal.sealed_date = nil
        seal.staff_nickname = nil
      end
    end
  end

  # The related leaf's last_date is contract's last month.
  def updateLeafLastdate
    Leaf.find(self.leaf_id).update_attribute(:last_date, self.seals.last.month)
  end
  
  #Seal's month must be unique in the leaf.
  def monthAlreadyExists?
    self.seals.each do |seal|
      if Contract.joins(:seals).where(
        "leaf_id = ? and seals.month = ?",
        self.leaf_id, seal.month
      ).exists?
        errors.add(:month, 'は既に契約済みです。')
        return false
      end
    end
  end

  # Terms length must not be changed after create!
  # Because this change causes empty terms in the leaf.
  def termsSameLength?
    prev = Contract.find(self.id)
    unless (self.term1 == prev.term1 && self.term2 == prev.term2)
      errors.add(:term1, '契約期間の変更はできません。')
    end
  end
  
  # Only the last contract is allowed to be deleted!
  def isLastContract?
    last = Leaf.find(self.leaf_id).contracts.last
    unless (self.id == last.id)
      errors.add(:start_month, '最後尾以外の契約は削除できません。')
      return false
    end
  end
  
  # Leaf's last_date should be backdated after the last contract deleted.
  def backdateLeafLastdate
    leaf = Leaf.find(self.leaf_id)
    last_contract = leaf.contracts.last

    # When deleting new contract or deleting whole the leaf,
    # there is no contract and leaf's last date is set to nil.
    unless last_contract.nil?
      leaf.update(last_date: last_contract.seals.last.month )
    else
      leaf.update(last_date: nil )
    end
  end
end
