# Models to validate format of date string
class DateFormatValidator
  include ActiveModel::Validations

  attr_accessor :date

  date_format =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :date, format: { with: date_format, allow_blank: true }

  def initialize(in_date)
    @date = in_date
  end
end
