# Model for count report for daily contracts
class DailyContractsReport
  include ActiveModel::Model

  attr_reader :contracts_date

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :contracts_date,
            format: { with: date_regexp }

  def initialize(in_contracts_date)
    @contracts_date = in_contracts_date.presence || Date.current
    @query = DailyContractsQuery.new(@contracts_date)
  end

  def contracts_list
    @query.list_each_contract
  end

  def contracts_total
    # Total(1) + vhiecle_type(3)
    result = Array.new(4) do
      # [ counts, total money ]
      [0, 0]
    end

    # Get counts and money of each vhiecle types.
    contracts_counts = @query.list_total_amount

    # Insert counts and money to each vhiecle_type's row.
    contracts_counts.each do |count|
      result[count[0]] = [count[1], count[2]]
    end

    # Add total counts and money to the first row.
    result[0] = result.transpose.map(&:sum)

    result
  end
end
