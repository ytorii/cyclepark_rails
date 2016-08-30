# Validator for query of searching unsealed numbers at particuler month.
class NumberSealsidListValidator
  include ActiveModel::Model

  attr_accessor :vhiecle_type_eq
  attr_accessor :valid_flag_eq
  attr_accessor :contracts_seals_month_eq
  attr_accessor :contracts_seals_sealed_flag_eq

  date_format =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :vhiecle_type_eq,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than: 4,
              allow_blank: true
            }
  validates :valid_flag_eq,
            inclusion: { in: [true, false] }
  validates :contracts_seals_month_eq,
            presence: true,
            format: { with: date_format, allow_blank: true }
  validates :contracts_seals_sealed_flag_eq,
            inclusion: { in: [true, false] }
end
