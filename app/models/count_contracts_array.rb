# Result Array of counting contracts
class CountContractsArray
  def initialize(in_month)
    @month = in_month
  end

  def count_contracts_array
    @month = @month.beginning_of_month
    prev_month = @month.prev_month
    next_month = @month.next_month

    # Each element has 7 elements below.
    # Vhiecle_type(3) + student_flag(2)+ largebike_flag(2)
    [present_counts_array(prev_month),
     new_counts_array(prev_month),
     present_counts_array(@month),
     new_counts_array(@month),
     present_counts_array(next_month),
     new_counts_array(next_month)]
  end

  private

  def present_counts_array(in_month)
    # The skipped contracts must not be included in counts.
    present_contracts =
      CountContractsQuery.new(in_month).count_present_contracts

    calc_count_array(present_contracts)
  end

  def new_counts_array(in_month)
    # New contracts' start_month is requested month.
    # It's NOT seal's month!
    new_contracts =
      CountContractsQuery.new(in_month).count_new_contracts

    calc_count_array(new_contracts)
  end

  # Convert grouped count hash from DB to count array including total
  def calc_count_array(in_counts)
    [first_normal_count(in_counts),
     first_student_count(in_counts),
     first_total_count(in_counts),
     bike_normal_count(in_counts),
     bike_large_count(in_counts),
     bike_total_count(in_counts),
     second_count(in_counts)]
  end

  # SQL results are grouped by 3 columns and can be selected by them.
  def first_normal_count(in_counts)
    in_counts[[1, false, false]].to_i
  end

  def first_student_count(in_counts)
    in_counts[[1, true, false]].to_i
  end

  def first_total_count(in_counts)
    in_counts[[1, false, false]].to_i + in_counts[[1, true, false]].to_i
  end

  def bike_normal_count(in_counts)
    in_counts[[2, false, false]].to_i
  end

  def bike_large_count(in_counts)
    in_counts[[2, false, true]].to_i
  end

  def bike_total_count(in_counts)
    in_counts[[2, false, false]].to_i + in_counts[[2, false, true]].to_i
  end

  def second_count(in_counts)
    in_counts[[3, false, false]].to_i
  end
end
