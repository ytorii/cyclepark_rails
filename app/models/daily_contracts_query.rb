# Query for daily contracts report
class DailyContractsQuery
  class << self
    def list_each_contract(contracts_date)
      Contract.joins(leaf: :customer)
      .where("contract_date = ?
                            and skip_flag = 'f'", contracts_date)
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

    def list_each_vhiecle_type(contracts_date)
      Contract.where(
        "contract_date = ? and skip_flag = 'f'", contracts_date
      )
      .joins(:leaf)
      .group(:vhiecle_type)
      .pluck('vhiecle_type, count(*), sum(money1 + money2)')
    end
  end
end
