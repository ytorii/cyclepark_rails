FactoryGirl.define do
  factory :multi_seals, class: MultiSealsUpdate do
    sealed_date "2016-03-31"
    staff_nickname "admin"
    #sealsid_list ["1", "3", "5", "6", ""]
    sealsid_list [ "1", "3", "5", "6" ]
  end
end
