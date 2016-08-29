# Model for count report for daily contracts
class DailyContractsReport
  include ActiveModel::Model

  attr_accessor :contracts_date
  attr_reader   :contracts_list
  attr_reader   :contracts_total

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :contracts_date,
            format: { with: date_regexp }

  def initialize(in_contracts_date)
    @contracts_date = in_contracts_date.presence || Date.current
  end

  def getContractsList
    result = Contract.joins(leaf: :customer)
                     .where("contract_date = ? and skip_flag = 'f'", @contracts_date)
                     .select('
       contracts.id,
       leafs.number AS number,
       leafs.vhiecle_type AS vhiecle_type,
       leafs.student_flag AS student_flag,
       leafs.largebike_flag AS largebike_flag,
       customers.first_name AS first_name,
       customers.last_name AS last_name,
       contracts.term1,
       contracts.term2,
       contracts.money1,
       contracts.money2,
       contracts.new_flag,
       contracts.staff_nickname
    ')
  end

  def calcContractsSummary
    # Total(1) + vhiecle_type(3)
    rows = 4

    # [ counts, total money ]
    result = Array.new(rows) do
      [0, 0]
    end

    # Get counts and money of each vhiecle types.
    contracts_counts = Contract.where(
      "contract_date = ? and skip_flag = 'f'", @contracts_date
    )
                               .joins(:leaf)
                               .group(:vhiecle_type)
                               .pluck('leafs.vhiecle_type, count(*), sum(money1 + money2)')

    # Insert counts and money to each vhiecle_type's row.
    contracts_counts.each do |count|
      result[count[0]] = [count[1], count[2]]
    end

    # Add total counts and money to the first row.
    result[0] = result.transpose.map(&:sum)

    result
  end
end
