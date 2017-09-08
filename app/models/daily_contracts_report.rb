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
    # Fill empty vhiecle_type 
    list_array_to_hash(vhiecle_type_list, blank_count_hash)
  end

  private

  # Get counts and money of each vhiecle types.
  def vhiecle_type_list
    @query.list_each_vhiecle_type(@contracts_date)
  end

  def list_array_to_hash(list_array, hash)
    list_array.each do |type_num, count, sum|
      type = vhiecle_type_map[type_num] 

      hash[type][:count] = count
      hash[type][:sum] = sum

      hash[:total][:count] += count
      hash[:total][:sum] += sum
    end

    hash
  end

    # Add total counts and money to the first row.
  def unshift_total_count(list)
    list.unshift(list.transpose.map(&:sum))
  end

  def blank_count_hash
    { total:  { count: 0, sum: 0 },
      first:  { count: 0, sum: 0 },
      bike:  { count: 0, sum: 0 },
      second:  { count: 0, sum: 0 } }
  end

  def vhiecle_type_map
    { 1 => :first, 2 => :bike, 3 => :second } 
  end
end
