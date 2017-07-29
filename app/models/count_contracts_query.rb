# Query for counting contracts
class CountContractsQuery
  class << self
    # The skipped contracts must not be included in counts.
    def count_present_contracts(month)
      Leaf.joins(contracts: :seals)
      .where("contracts.skip_flag = 'f'
                                and seals.month = ?", month)
      .group(:vhiecle_type, :student_flag, :largebike_flag)
      .count
    end

    # New contracts' start_month is requested month.
    # It's NOT seal's month!
    def count_new_contracts(month)
      Leaf.
        where(start_date: month.beginning_of_month..month.end_of_month).
        group(:vhiecle_type, :student_flag, :largebike_flag).
        count
    end

    def count_next_unsigned_contracts(month)
      Leaf.
        where("last_date = ?", month.end_of_month).
        group(:vhiecle_type, :student_flag, :largebike_flag).
        count
    end

    def count_next_skip_contracts(month)
      query = ActiveRecord::Base.send(:sanitize_sql_array,
              [ count_next_skip_raw_sql, month.next_month, month ])

      count_array = ActiveRecord::Base.connection.select_all(query).rows

      count_array_to_hash(count_array)
    end

    private

    def count_next_skip_raw_sql
      "select vhiecle_type, student_flag, largebike_flag, count(*) " +
        "from leafs inner join contracts on contracts.leaf_id = leafs.id " +
        "where skip_flag = 't' and start_month = ? and " +
        "leafs.id in (select leaf_id from contracts inner join seals " +
        "on seals.contract_id = contracts.id " +
        "where month = ? and skip_flag = 'f')" +
        "group by vhiecle_type, student_flag, largebike_flag"
    end

    def count_array_to_hash(array, hash={})
      array.map{ |e|
        hash[[e[0], to_boolean(e[1]), to_boolean(e[2])]] = e[3]
      }
      hash
    end

    def to_boolean(string)
      string == 't'
    end
  end
end
