class Contract < ActiveRecord::Base
  belongs_to :leaf, counter_cache: true
  has_many :seals, dependent: :destroy
  accepts_nested_attributes_for :seals

  date_format = /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/

  validates :contract_date,
    presence: true,
    format: { with: date_format, allow_blank: true}
  validates :start_month,
    presence: true,
    format: { with: date_format, allow_blank: true}
  validates :term1,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validates :money1,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true }
  validates :term2,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 10, allow_blank: true }
  validates :money2,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true }
  validates :new_flag,
    inclusion: {in: [true, false]}
  validates :skip_flag,
    inclusion: {in: [true, false]}
  validate :staffExists?
  validate :monthAlreadyExists?, on: :create
  validate :termsSameLength?, on: :update

  before_validation do
    # Setting params are needed only when create new records
    if self.new_record?
      setContractParams
      setFirstSealParams
      setRestSealsParams
    # Setting params for correcting existing records,
    # especially in correcting seal records.
    else
      setCanceledSealsParams
    end
  end

  before_create do
    updateLeafLastdate
  end

  before_destroy :isLastContract?
  after_destroy :backdateLeafLastdate

  scope :daily_contracts_scope, -> (in_contract_date){
    joins(leaf: :customer)
    .where('contract_date = ?', in_contract_date)
    .select('
       leafs.number AS number,
       leafs.vhiecle_type AS vhiecle_type,
       customers.first_name AS first_name,
       customers.last_name AS last_name,
       contracts.term1,
       contracts.term2,
       contracts.money1,
       contracts.money2, 
       contracts.staff_nickname, 
       contracts.contract_date
    ')
  }

  def Contract.calcContractsSummary(inContractDate)

    # Total(1) + vhiecle_type(3)
    rows = 4

    # [ counts, money ]
    result = Array.new(rows) do
      [0, 0]
    end

    # Get counts and money of each vhiecle types.
    contracts_counts = Contract.where('contract_date = ?', inContractDate)
                     .joins(:leaf)
                     .group(:vhiecle_type)
                     .pluck('leafs.vhiecle_type,
                             count(*),
                             sum(money1 + money2)')

    # Insert counts and money to each vhiecle_type's row.
    contracts_counts.each do |count|
      result[count[0]] = [ count[1], count[2] ]
    end
    
    # Add total counts and money to the first row.
    result[0] = result.transpose.map(&:sum)

    result
  end

  private
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

    # The skipped contracts has only one term and no money.
    if self.skip_flag
      self.term1 = 1
      self.term2 = 0
      self.money1 = 0
      self.money2 = 0
    else
      # The skip_flag should be false if the input value is nil.
      self.skip_flag = false

      # Nil inputs is transformed to 0 by the to_i method.
      self.term2 = self.term2.to_i
      self.money2 = self.money2.to_i
    end
  end

  # First Seal needs to insert parameters before validation.
  # Because its parameters depend on inputs from web pages.
  def setFirstSealParams
    first_seal = self.seals.first

    if first_seal.sealed_flag
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

  # staff_nickname must exist in StaffDB.
  def staffExists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
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
      errors.add(:start_month, '最後尾以外の契約は削除できません。i')
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

  def self.ransackable_scopes(auth_object = nil)
    %i[daily_contracts_scope]
  end
end
