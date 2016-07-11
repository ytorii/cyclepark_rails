class CountContractsSummary
  include ActiveModel::Model

  attr_accessor :month

  date_format =
    /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/

  validates :month,
    format: { with: date_format }

  def initialize(in_month)
    @month = in_month.presence || Date.today
  end

  def countContractsSummary
    # This, diffs from prev, new this, next, next_unpaid, new_next
    rows = 6

    # About initializing matrix of array, see '楽しいRuby' p268.
    count_array = Array.new(rows) do
      # Vhiecle_type(3) + student_flag(2)+ largebike_flag(2)
      [0, 0, 0, 0, 0, 0, 0]
    end

    # Count starts from previous month
    @month = @month.prev_month.beginning_of_month

    # Count new and extend contracts of prev, present, next month.
    0.step( rows-1, 2 ) do |i|
      count_array[i]   = countContracts(@month)
      count_array[i+1] = countNewContracts(@month)
      @month = @month.next_month
    end

    # Return the result as hash.
    result = {
     "present_total" => count_array[2],
     "present_new" => count_array[3],
     "next_total" => count_array[4],
     "next_new" => count_array[5],

     # Diffs from prev_month = this_month - prev_month
     "diffs_prev" =>
       [count_array[2], count_array[0]].transpose.map{|f, s| f - s},

     # Next_unpaid = present_total - (next_total - next_new)
     # This value should'nt be smaller than 0, and first and bike's
     # total count should be calculated again to avoid unmatched values.
     "next_unpaid" =>
       [count_array[2], count_array[4], count_array[5]].transpose.map{
         |f, s, t| (f - s + t) >= 0 ? f - s + t : 0
       }.tap{ |array|
         array[2] = array[0] + array[1]
         array[5] = array[3] + array[4]
       }
    }
  end
  
  private
  def countContracts(in_month) 
    # The skipped contracts must not be included in counts.
    contracts_count = Leaf.joins(contracts: :seals)
      .where("contracts.skip_flag = 'f' and seals.month = ?", in_month)
      .group(:vhiecle_type, :student_flag, :largebike_flag)
      .count

    setCountArray(contracts_count)
  end

  def countNewContracts(in_month)
    # New contracts' start_month is requested month.
    # It's NOT seal's month!
    new_contracts_count = Leaf.joins(:contracts)
      .where("contracts.new_flag = 't' and contracts.start_month = ?", in_month)
      .group(:vhiecle_type, :student_flag, :largebike_flag)
      .count

    setCountArray(new_contracts_count)
  end

  # Convert count result hash from DB to count array including total
  def setCountArray(inCounts)

    count_array = [0, 0, 0, 0, 0, 0, 0]

    # SQL results are grouped by 3 columns and can be selected by them.
    count_array[0] = inCounts[[1, false, false]].to_i
    count_array[1] = inCounts[[1, true, false]].to_i
    count_array[2] = count_array[0] + count_array[1]
    count_array[3] = inCounts[[2, false, false]].to_i
    count_array[4] = inCounts[[2, false, true]].to_i
    count_array[5] = count_array[3] + count_array[4]
    count_array[6] = inCounts[[3, false, false]].to_i

    count_array
  end
end
