class Contract < ActiveRecord::Base
  belongs_to :leaf, counter_cache: true
  has_many :seals, dependent: :destroy
  accepts_nested_attributes_for :seals

  validates :contract_date,
    presence: true,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, allow_blank: true}
  validates :start_month,
    presence: true,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, allow_blank: true}
  validates :term1,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validates :money1,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true }
  validates :term2,
    numericality: { if: 'term2.present?', greater_than: 0, less_than: 10 }
  validates :money2,
    presence: { if: 'term2.present?' },
    numericality: { greater_than_or_equal_to: 0, less_than: 18001, allow_blank: true }
  validates :new_flag,
    inclusion: {in: [true, false]}
  validates :skip_flag,
    inclusion: {in: [true, false]}
  validate :staff_exists?
  validate :terms_same_length?, on: :update

  before_validation do
    # Setting params are needed only when create new records
    if self.new_record?
      setContractParams
      setFirstSealParams
    else
      setSealCancelParams
    end
  end

  before_create do
    setRestSealsParams
    updateLeafLastdate
  end

  before_destroy :isLastContract?
  after_destroy :backdateLeafLastdate

  private
  # New_flag and start_month should be determined automatically
  # iside the model itself.
  def setContractParams
    leaf = Leaf.find(self.leaf_id)

    if (leaf.contracts.size == 0)
      self.new_flag = true
      self.start_month = leaf.start_date
    else
      self.new_flag = false
      self.start_month = leaf.last_date.next_month
    end
  end

  # First Seal needs to insert parameters before validation.
  # Because its parameters depend on inputs from web pages.
  def setFirstSealParams
    if self.seals.first.sealed_flag
      self.seals.first.attributes = { month: self.start_month, sealed_date: self.contract_date, staff_nickname: self.staff_nickname }
    else
      self.seals.first.attributes = { month: self.start_month, sealed_date: nil, staff_nickname: nil }
    end
  end

  # The rest of Seals should be inserted parameters after validation.
  # At before validation, this causes unnessesary errors.
  def setRestSealsParams
    month = self.start_month

    # term1 and term2 must be translated to 0 when they are nil or false.
    (self.term1.to_i + self.term2.to_i - 1).times do |term|
      month = month.next_month
      self.seals.build(month: month, sealed_flag: false)
    end
  end

  # All canceled Seal should initialize date and nickname.
  def setSealCancelParams
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
  def staff_exists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
  end
  
  # Terms length must not be changed after create!
  def terms_same_length?
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
  
  # Leaf's last_date should be backdated after contract delete.
  def backdateLeafLastdate
    leaf = Leaf.find(self.leaf_id)
    leaf.update_attribute(:last_date, leaf.contracts.last.seals.last.month )
  end
end
