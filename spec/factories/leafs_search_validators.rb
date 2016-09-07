FactoryGirl.define do
  factory :leafs_search_validator do
    vhiecle_type_eq '1'
    number_eq '1'
    valid_flag_eq 'true'
    customer_first_name_or_customer_last_name_cont '自転車'
  end
end
