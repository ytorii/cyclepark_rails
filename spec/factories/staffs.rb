FactoryGirl.define do
  factory :admin, class: Staff do
    nickname "admin"
    password "12345678"
    admin_flag true
    
    after(:create) do |admin|
      create(:admindetail, staff: admin)
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

  factory :admin2, class: Staff do
    nickname "admin"
    password "12345678"
    admin_flag true
    
    after(:create) do |admin2|
      create(:admindetail, staff: admin2)
    end
  end
end
