FactoryGirl.define do
  factory :first_seal, class: Seal do
    Contract
    month ""
    sealed_flag true
    sealed_date ""
    staff_nickname ""
  end

  factory :first_seal_add, class: Seal do
    Contract
    month "2016-01-01"
    sealed_flag false
    sealed_date "2016-01-01"
    staff_nickname "admin"
  end

end
