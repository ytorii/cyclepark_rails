FactoryGirl.define do
  factory :seal_true, class: Seal do
    Contract
    month "2016-02-01"
    sealed_flag true
    sealed_date ""
    staff_nickname ""
  end

  factory :seal_false, class: Seal do
    Contract
    month "2016-02-01"
    sealed_flag false
    sealed_date ""
    staff_nickname ""
  end

  factory :first_seal, class: Seal do
    Contract
    month "2016-02-01"
    sealed_flag true
    sealed_date "2016-01-25"
    staff_nickname "admin"
  end

  factory :seal_multi, class: Seal do
    sequence(:contract_id) { |n| n}
    month "2016-04-01"
    sealed_flag false
    sealed_date nil
    staff_nickname nil
  end

end
