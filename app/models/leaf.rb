class Leaf < ActiveRecord::Base
  has_one :customer, dependent: :destroy
  has_many :contracts, dependent: :destroy
  
  # This parametor is needed to use multiple models in the same form.
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :contracts

  validates :number,
    presence: true,
    numericality: { greater_than: 0, less_than: 1013, allow_blank: true }
  validates :vhiecle_type,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validates :student_flag,
    inclusion: {in: [true, false]}
  validates :largebike_flag,
    inclusion: {in: [true, false]}
  validates :valid_flag,
    inclusion: {in: [true, false]}
  validates :start_date,
    presence: true,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, allow_blank: true}
  validates :last_date,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, unless: 'last_date.blank?'}
  validate :sameNumberExists?, on: :create

  before_destroy :isInvalidLeaf?

  # The skipped contracts must not be included in number of contracts.
  scope :count_contracts, ->(vhiecle_type, month) {
    joins(contracts: :seals).where(
      "vhiecle_type = ? and
       contracts.skip_flag = ? and
       seals.month = ?",
       vhiecle_type, false, month
    ).count
  }

  #This method is public because it's called by controller.
  def self.countContractsSummary

    # The number of vhiecle_type + 1(total)
    rows = 7

    # About initializing matrix of array, see '楽しいRuby' p268.
    result = Array.new(rows) do
      [0, 0, 0, 0, 0, 0, 0]
    end

    month = Date.today.beginning_of_month
    p Leaf.count_contracts(1, month)
    p Leaf.count_contracts(2, month)

  end

  private
  # Only the invalid leaf is allowed to be deleted!
  def isInvalidLeaf?
    if self.valid_flag
      errors.add(:valid_flag, '契約中のリーフは削除できません。')
      return false
    end
  end

  def sameNumberExists?
    if Leaf.where('number = ? and vhiecle_type = ? and valid_flag = ?', self.number, self.vhiecle_type, true).exists?
      errors.add(:number, '指定された番号は既に使用されています。')
      return false
    end
  end
end
