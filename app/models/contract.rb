# Model for customer'S contracts
class Contract < ActiveRecord::Base
  include StaffsExist
  include ContractsValidate
  include ContractsSetParams

  belongs_to :leaf, counter_cache: true, inverse_of: :contracts
  has_many :seals, dependent: :destroy, inverse_of: :contract
  accepts_nested_attributes_for :seals

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  # New_flag is set by this model, so no need to be validated.
  validates :contract_date,
            presence: true,
            format: { with: date_regexp, allow_blank: true }
  # Term1 must be longer than 0 because 0 length contract is not allowed.
  validates :term1,
            presence: { unless: 'skip_flag' },
            numericality:
              { greater_than: 0, less_than: 13, allow_blank: true }
  validates :money1,
            presence: { unless: 'skip_flag' },
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 36_001,
                allow_blank: true }
  # Term2 and money2 is allowed to be nil, because nil is set to 0.
  validates :term2,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 10,
                allow_blank: true }
  validates :money2,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than: 18_001,
                allow_blank: true }
  validates :skip_flag,
            inclusion: { in: [true, false] }
  validate :staff_exists?
  validate :same_length_terms?, on: :update

  # Only the last contract can be deleted
  before_destroy :last_contract?

  before_save do
    if skip_flag
      set_skipcontract_params
    else
      set_nilcontract_params
    end
  end

  before_create do
    # Seals needs to insert parameters before validation.
    # Because first seal parameters depend on inputs from web pages.
    set_contract_params
    set_seals_params
  end

  before_update do
    # Setting params for editing exist records,
    # especially in editing seal records.
    set_canceledseals_params
  end

  after_create :update_leaf_lastdate

  after_destroy :backdate_leaf_lastdate
end
