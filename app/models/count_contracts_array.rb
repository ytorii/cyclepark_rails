# Result Array of counting contracts
#
# Returns Hash of array below:
#
# this_total,
# prev_total,
# next_total,
# next_unsigned,
# next_skip,
# this_new,
# next_new
class CountContractsArray
  def initialize(params)
    @month = params[:month]
    @query = params[:query]
  end

  def count_contracts
    set_hash_value_to_array(count_hash)
  end

  private

  def count_hash
    { this_total: this_total_count,
      prev_total: prev_total_count,
      next_total: next_total_count,
      next_unsigned: next_unsigned_count,
      next_skip: next_skip_count,
      this_new: this_new_count,
      next_new: next_new_count }
  end

  def this_total_count
    @query.count_total_contracts(@month)
  end

  def prev_total_count
    @query.count_total_contracts(@month.prev_month)
  end

  def next_total_count
    @query.count_total_contracts(@month.next_month)
  end

  def this_new_count
    @query.count_new_contracts(@month)
  end

  def next_new_count
    @query.count_new_contracts(@month.next_month)
  end

  def next_skip_count
    @query.count_next_skip_contracts(@month)
  end

  def next_unsigned_count
    @query.count_next_unsigned_contracts(@month)
  end

  def set_hash_value_to_array(hash)
    hash.each{ |k, v| hash[k] = hash_to_array(v) }
  end

  def hash_to_array(hash)
    array = Array.new(5){0}
    hash.each{ |k, v| array[position[k]] = v }
    array
  end

  def position
    { [1, false, false] => 0,
      [1, true,  false] => 1,
      [2, false, false] => 2,
      [2, false, true]  => 3,
      [3, false, false] => 4 }
  end
end
