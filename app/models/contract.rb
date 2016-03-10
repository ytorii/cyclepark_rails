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

  # First Seal needs to insert parameters before validation.
  before_validation do
    setContractParams
    setFirstSealParams
  end

  # The rest of Seals needs to insert parameters after validation.
  # The related leaf's last_date is contract's last month.
  before_save do
   setRestSealsParams
   updateLeafLastdate
  end

  private
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

  def setFirstSealParams
    if self.seals.first.sealed_flag
      self.seals.first.attributes = {month: self.start_month, sealed_date: self.contract_date, staff_nickname: self.staff_nickname}
    else
      self.seals.first.month = self.start_month
    end
  end

  def setRestSealsParams
    month = self.start_month
    #term2 = self.term2.present? ? self.term2 : 0
    (self.term1.to_i + self.term2.to_i - 1).times do |term|
      month = month.next_month
      self.seals.build(month: month, sealed_flag: false)
    end
  end

  def updateLeafLastdate
    Leaf.find(self.leaf_id).update_attribute(:last_date, self.seals.last.month)
  end

  def staff_exists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
  end
end
