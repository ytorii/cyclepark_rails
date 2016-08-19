FactoryGirl.define do
  factory :test, class: Staff do
    nickname "test"
    password "12345678"
    admin_flag true
    
    after(:create) do |test|
      create(:admindetail, staff: test)
    end
  end

  factory :normal, class: Staff do
    nickname "normal"
    password "abcdefgh"
    admin_flag false
    
    after(:create) do |normal|
      create(:normaldetail, staff: normal)
    end
  end

  factory :test2, class: Staff do
    nickname "test"
    password "12345678"
    admin_flag true
    
    after(:create) do |test2|
      create(:admindetail, staff: test2)
    end
  end
end
