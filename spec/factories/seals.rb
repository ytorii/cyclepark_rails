FactoryGirl.define do
  factory :seal_true, class: Seal do
    Contract
    month "2016-02-20"
    sealed_flag true
    sealed_date "2016-02-20"
    staff_nickname "admin"
  end

  factory :seal_false, class: Seal do
    Contract
    month ""
    sealed_flag false
    sealed_date ""
    staff_nickname ""
  end

end
