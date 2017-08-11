# Models to count the number of customer's for statistics.
class CountContractsSummary
  attr_accessor :month

  def initialize(in_month)
    @month = in_month ? Date.parse(in_month) : Date.current
  end

  def report_summary
    insert_sums_to_array(summary_hash)
  end

  private
  def insert_sums_to_array(hash)
    hash.each do |key, array| 
      array.insert(2, array[0] + array[1])
      array.insert(-2, array[-3] + array[-2])
    end
  end

  def summary_hash
    { present_total: contracts_counts[:this_total],
      present_new:   contracts_counts[:this_new],
      next_total:    contracts_counts[:next_total],
      next_new:      contracts_counts[:next_new],
      next_unpaid:   sum_array(
        contracts_counts[:next_unsigned], contracts_counts[:next_skip]),
      diffs_prev:    diff_array(
        contracts_counts[:this_total], contracts_counts[:prev_total]) }
  end

  def contracts_counts
    @counts ||= counts_array.count_contracts
  end

  def counts_array
    CountContractsArray.new(array_params)
  end

  def array_params
    { month: @month.beginning_of_month,
      query: count_contracts_query }
  end

  def count_contracts_query
    CountContractsQuery
  end

  def sum_array(ary1, ary2)
    ary1.zip(ary2).map{|f, s| f + s }
  end

  def diff_array(ary1, ary2)
    ary1.zip(ary2).map{|f, s| f - s }
  end
end
