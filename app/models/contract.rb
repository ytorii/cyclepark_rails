# Model for customer'S contracts
class Contract < ActiveRecord::Base
  include StaffsExist
  include ContractsValidate

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
              { greater_than_or_equal_to: 1,
                less_than_or_equal_to: 12,
                allow_blank: true }
  validates :money1,
            presence: { unless: 'skip_flag' },
            numericality:
              { greater_than_or_equal_to: 0,
                less_than_or_equal_to: 36_000,
                allow_blank: true }
  # Term2 and money2 is allowed to be nil, because nil is set to 0.
  validates :term2,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than_or_equal_to: 6,
                allow_blank: true }
  validates :money2,
            numericality:
              { greater_than_or_equal_to: 0,
                less_than_or_equal_to: 18_000,
                allow_blank: true }
  validates :skip_flag, inclusion: { in: [true, false] }
  validate :staff_exists?, on: :update
  validate :terms_unchanged?, on: :update

  # Only the last contract can be deleted
  before_destroy :last_contract?

  before_save ContractParamsSetup

  before_create ContractParamsSetup

  before_update ContractParamsSetup

  after_create LeafLastDateUpdator

  after_destroy LeafLastDateUpdator
end
