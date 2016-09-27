# Creating the list of leafs' numbers and seals' ids of the specified month.
class NumberSealsidListSearch
  include ActiveModel::Model

  attr_accessor :vhiecle_type
  attr_accessor :month
  attr_accessor :sealed_flag

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :vhiecle_type,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than: 4,
              allow_blank: true
            }
  validates :month,
            presence: true,
            format: { with: date_regexp, allow_blank: true }
  validates :sealed_flag,
            inclusion: { in: [true, false] }

  # Month should be next month of today,
  # because the most of unsticked seals are of next month.
  def initialize(
    vhiecle_type = 1,
    month = Date.current.next_month,
    sealed_flag = false
  )
    @vhiecle_type = vhiecle_type
    @month = month
    @sealed_flag = cast_to_boolean(sealed_flag)
  end

  # DO NOT start with Leaf! That causes a slow query.
  def result
    Seal.where('month = ? and sealed_flag = ? and vhiecle_type = ?',
               change_to_beginning_of_month, @sealed_flag, @vhiecle_type)
        .joins(contract: :leaf)
        .select('number, seals.id as seal_id')
        .order('number')
  end

  private

  # Months are recorded as the 1st day of the each month.
  def change_to_beginning_of_month
    @month.to_date.beginning_of_month
  end

  # Params from controllers are String, so need to be casted to Boolean.
  def cast_to_boolean(input)
    ActiveRecord::Type::Boolean.new.type_cast_from_user(input)
  end
end
