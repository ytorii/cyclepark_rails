# Validate parameters for searching leafs
class LeafsSearchValidator
  include ActiveModel::Model

  attr_accessor :vhiecle_type_eq
  attr_accessor :number_eq
  attr_accessor :valid_flag_eq
  attr_accessor :customer_first_name_or_customer_last_name_cont

  # Ransack params are given as String, so vhiecle_types and valid_flags
  # are checked by string expression!
  validates :vhiecle_type_eq,
            presence: { if: :number_search? },
            numericality: {
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 3,
              allow_blank: true
            }
  validates :number_eq,
            presence: { if: :number_search? },
            numericality: {
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 1056,
              allow_blank: true
            }
  validates :valid_flag_eq,
            inclusion: { in: [true, false], if: :number_search? }
  validates :customer_first_name_or_customer_last_name_cont,
            presence: { unless: :number_search? }

  # When number query exists, number search is executed
  # even though name input is present!
  def number_search?
    number_eq.present? || vhiecle_type_eq.present? || valid_flag_eq.present?
  end
end
