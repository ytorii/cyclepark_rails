# Model for count report for daily contracts
class DailyContractsReport
  include ActiveModel::Model

  attr_accessor :contracts_date

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :contracts_date,
            format: { with: date_regexp }

  def initialize(params={})
    @contracts_date = params[:contracts_date].presence || Date.current
    @query = params[:query]
  end

  def contracts_list
    @query.list_each_contract(@contracts_date)
  end

  def contracts_total
    list = vhiecle_type_list
    list = blank_list if list.blank?

    # Add total counts and money to the first row.
    list.unshift(total_count(list))
  end

  private

  # Get counts and money of each vhiecle types.
  def vhiecle_type_list
    @query.list_each_vhiecle_type(@contracts_date)
  end

  def blank_list
    # vhiecle_type(3)
    # [ counts, total_money ]
    result = Array.new(3) { [0, 0] }
  end

  def total_count(list)
    list.transpose.map(&:sum)
  end
end
