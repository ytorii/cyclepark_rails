# Query for counting contracts
class CountContractsQuery
  def initialize(in_month)
    @month = in_month
  end

  def count_present_contracts
    # The skipped contracts must not be included in counts.
    Leaf.joins(contracts: :seals)
        .where("contracts.skip_flag = 'f'
                                and seals.month = ?", @month)
        .group(:vhiecle_type,
               :student_flag,
               :largebike_flag)
        .count
  end

  def count_new_contracts
    # New contracts' start_month is requested month.
    # It's NOT seal's month!
    Leaf.joins(:contracts)
        .where("contracts.new_flag = 't' and
                                    contracts.start_month = ?", @month)
        .group(:vhiecle_type,
               :student_flag,
               :largebike_flag)
        .count
  end
end
