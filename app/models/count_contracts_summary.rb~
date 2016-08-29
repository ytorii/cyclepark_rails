# Models to count the number of customer's for statistics.
class CountContractsSummary
  include ActiveModel::Model

  attr_accessor :month

  date_format =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :month, format: { with: date_format }

  def initialize(in_month)
    @month = in_month.presence || Date.current
    @contracts_array = CountContractsArray.new
  end

  def count_contracts_summary
    # 6rows, today, diffs prev, new_today, next, next_unpaid, new_next.
    count_array = Array.new(6) do
      # Vhiecle_type(3) + student_flag(2)+ largebike_flag(2)
      [0, 0, 0, 0, 0, 0, 0]
    end

    # Count starts from previous month
    @month = @month.prev_month.beginning_of_month

    # Count new and extend contracts of prev, present, next month.
    0.step(5, 2) do |i|
      count_array[i] = @contracts_array.present_counts_array(@month)
      count_array[i + 1] = @contracts_array.new_counts_array(@month)
      @month = @month.next_month
    end

    # Return the result as hash.
    count_result_hash(count_array)
  end

  private

  def count_result_hash(in_ary)
    {
      'present_total' => in_ary[2],
      'present_new' => in_ary[3],
      'next_total' => in_ary[4],
      'next_new' => in_ary[5],
      'diffs_prev' => diff_array(in_ary[2], in_ary[0]),
      'next_unpaid' => unpaid_array(in_ary[2], in_ary[4], in_ary[5])
    }
  end

  # Diffs from prev_month = this_month - prev_month
  def diff_array(ary1, ary2)
    [ary1, ary2].transpose.map { |f, s| f - s }
  end

  # Next_unpaid = present_total - (next_total - next_new)
  # This value should'nt be smaller than 0, and first and bike's
  # total count should be calculated again to avoid unmatched values.
  def unpaid_array(ary1, ary2, ary3)
    [ary1, ary2, ary3]
      .transpose
      .map { |f, s, t| (f - s + t) >= 0 ? f - s + t : 0 }
      .tap do |array|
      array[2] = array[0] + array[1]
      array[5] = array[3] + array[4]
    end
  end
end
