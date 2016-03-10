FactoryGirl.define do
  factory :first_contract, class: Contract do
    Leaf
    contract_date "2016-02-20"
    start_month ""
    term1 1
    money1 1000 
    term2 6
    money2 18000
    new_flag false
    skip_flag false
    staff_nickname "admin"

    after(:build) do |first_contract|
      build(:first_seal, contract: first_contract)
    end
  end

  factory :first_contract_add, class: Contract do
    Leaf
    contract_date "2016-01-01"
    start_month ""
    term1 1
    money1 3500 
    term2 ''
    money2 ''
    new_flag true
    skip_flag false
    staff_nickname "admin"

    after(:create) do |first_contract_add|
      create(:first_seal_add, contract: first_contract_add)
    end
  end
end
