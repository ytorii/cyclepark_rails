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
  scope :count_contracts,
    ->(vhiecle_type, student_flag, largebike_flag, month) {
    joins(contracts: :seals).where(
      "vhiecle_type = ? and
         student_flag = ? and
         largebike_flag = ? and
         contracts.skip_flag = 'f' and
         seals.month = ?",
         vhiecle_type, student_flag, largebike_flag, month
    ).count
  }

  # New contracts' start_month is selected month.
  # It's NOT seals' month!
  scope :count_new_contracts,
    ->(vhiecle_type, student_flag, largebike_flag, month) {
    joins(:contracts).where(
      "vhiecle_type = ? and
       student_flag = ? and
       largebike_flag = ? and
       contracts.new_flag = 't' and
       contracts.start_month = ?",
       vhiecle_type, student_flag, largebike_flag, month
    ).count
  }

  #This method is public because it's called by controller.
  def self.countContractsSummary

    result = Hash.new

    # This, diffs from prev, new this, next, next_unpaid, new_next
    rows = 6

    # About initializing matrix of array, see '楽しいRuby' p268.
    count_array = Array.new(rows) do
      # Vhiecle_type(3) + student_flag(2)+ largebike_flag(2)
      [0, 0, 0, 0, 0, 0, 0]
    end

    # Count new and extend contracts of prev, present, next month.
    month = Date.today.prev_month.beginning_of_month
    i = 0
    while i < 6 do
      count_array[i] = countMonthlyContracts(month)
      count_array[i+1] = countMonthlyNewContracts(month)
      i += 2
      month = month.next_month
    end

    result.store( "present_total", count_array[2]) 
    result.store( "present_new", count_array[3])
    result.store( "next_total", count_array[4])
    result.store( "next_new", count_array[5])

    # Diffs from prev_month = this_month - prev_month
    result.store( "diffs_prev",
     [count_array[2], count_array[0]].transpose.map{|f, s| f - s}) 

    # Next_unpaid = present_total - (next_total - next_new)
    result.store( "next_unpaid",
     [count_array[2], count_array[4], count_array[5]].transpose.map{
       |f, s, t| f - s + t
      }
    )

    result

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
    if Leaf.where( 'number = ? and vhiecle_type = ? and valid_flag = ?',
       self.number, self.vhiecle_type, true).exists?
      errors.add(:number, '指定された番号は既に使用されています。')
      return false
    end
  end

  def self.countMonthlyContracts(month)
    result = [0, 0, 0, 0, 0, 0, 0]
    result[0] = Leaf.count_contracts(1, false, false, month)
    result[1] = Leaf.count_contracts(1, true, false, month)
    result[2] = result[0] + result[1]
    result[3] = Leaf.count_contracts(2, false, false, month)
    result[4] = Leaf.count_contracts(2, false, true, month)
    result[5] = result[3] + result[4]
    result[6] = Leaf.count_contracts(3, false, false, month)

    result
  end

  def self.countMonthlyNewContracts(month)
    result = [0, 0, 0, 0, 0, 0, 0]

    result[0] = Leaf.count_new_contracts(1, false, false, month)
    result[1] = Leaf.count_new_contracts(1, true, false, month)
    result[2] = result[0] + result[1]
    result[3] = Leaf.count_new_contracts(2, false, false, month)
    result[4] = Leaf.count_new_contracts(2, false, true, month)
    result[5] = result[3] + result[4]
    result[6] = Leaf.count_new_contracts(3, false, false, month)

    result
  end
end
