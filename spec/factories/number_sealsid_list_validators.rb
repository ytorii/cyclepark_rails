FactoryGirl.define do
  factory :number_sealsid_list_validator do
    vhiecle_type_eq 1
    valid_flag_eq   true
    contracts_seals_month_eq '2016-05-01'
    contracts_seals_sealed_flag_eq false
  end
end
