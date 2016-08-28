# Model for customer'S contracts
class Contract < ActiveRecord::Base
  include StaffsExist
  include ContractsValidate
  include ContractsSetParams

  belongs_to :leaf, counter_cache: true
  has_many :seals, dependent: :destroy
  accepts_nested_attributes_for :seals

  date_regexp = %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :contract_date,
            presence: true,
            format: { with: date_regexp, allow_blank: true }
  validates :start_month,
            presence: true,
            format: { with: date_regexp, allow_blank: true }
  # Term1 must be longer than 0 because 0 length contract is not allowed.
  validates :term1,
            presence: true,
            numericality:
              { greater_than: 0, less_than: 13, allow_blank: true }
  validates :money1,
            presence: true,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 36_001,
                allow_blank: true }
  validates :term2,
            presence: true,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 10,
                allow_blank: true }
  validates :money2,
            presence: true,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 18_001,
                allow_blank: true }
  validates :new_flag,
            inclusion: { in: [true, false] }
  validates :skip_flag,
            inclusion: { in: [true, false] }
  validate :staffExists?
  validate :month_exists?, on: :create
  validate :same_length_terms?, on: :update

  before_validation do
    if skip_flag
      set_skipcontract_params
    else
      set_nilcontract_params
    end

    if self.new_record?
      # Seals needs to insert parameters before validation.
      # Because first seal parameters depend on inputs from web pages.
      set_contract_params
      set_seals_params
    else
      # Setting params for editing exist records,
      # especially in editing seal records.
      set_canceledseals_params
    end
  end

  after_create :update_leaf_lastdate

  # Only the last contract can be deleted
  before_destroy :last_contract?
  after_destroy :backdate_leaf_lastdate
end
