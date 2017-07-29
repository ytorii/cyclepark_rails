FactoryGirl.define do
  factory :first_contract, class: Contract do
    Leaf
    contract_date "2016-02-20"
    start_month "2016-02-01"
    term1 1
    money1 1000 
    term2 6
    money2 18000
    new_flag false
    skip_flag false
    staff_nickname "admin"

    after(:build) do |contract|
      contract.seals.build(sealed_flag: true)
    end

    factory :first_contract_no_callbacks, class: Contract do
      after(:build) do |contract|
        Contract.reset_callbacks :create
        Contract.reset_callbacks :update
        Contract.reset_callbacks :destroy
      end

      factory :first_contract_no_callbacks_seals, class: Contract do
        after(:build) do |contract|
          contract.seals.first.month = contract.start_month
          1.upto 6 do |i|
            contract.seals.build(month: contract.start_month + i.months)
          end
        end
      end
    end
  end

  factory :first_contract_false, class: Contract do
    Leaf
    contract_date Date.today
    start_month Date.today.next_month
    term1 1
    money1 1000 
    term2 6
    money2 18000
    new_flag false
    skip_flag false
    staff_nickname "admin"

    after(:build) do |contract|
      contract.seals.build(sealed_flag: false)
    end
  end

  factory :first_contract_add, class: Contract do
    Leaf
    contract_date "2016-02-01"
    start_month "2016-02-01"
    term1 1
    money1 3500 
    term2 nil
    money2 nil
    new_flag true
    skip_flag false
    staff_nickname "admin"

    after(:build) do |first_contract_add|
      first_contract_add.seals.build(sealed_flag: false)
    end
  end

  factory :first_contract_edit, class: Contract do
    Leaf
    contract_date "2016-01-01"
    start_month nil
    term1 1
    money1 3500 
    term2 nil
    money2 nil
    new_flag true
    skip_flag false
    staff_nickname "admin"

    after(:build) do |first_contract_edit|
      first_contract_edit.seals.build(sealed_flag: false)
    end
  end

  factory :daily_cont, class: Contract do
    Leaf
    contract_date "2016-01-16"
    staff_nickname "admin"
    start_month "2016-02-01"
    skip_flag false

    after(:build) do |contract|
      contract.seals.build(sealed_flag: false)
    end

    factory :daily_cont_first_1, class: Contract do
      term1 1
      money1 2000 
      term2 6
      money2 18000
    end

    factory :daily_cont_first_2, class: Contract do
      term1 1
      money1 0 
      skip_flag true
    end

    factory :daily_cont_student_1, class: Contract do
      term1 3
      money1 8500 
    end

    factory :daily_cont_bike_1, class: Contract do
      term1 1
      money1 2800 
      term2 1
      money2 5500
    end

    factory :daily_cont_large_bike_1, class: Contract do
      term1 1
      money1 6500 
    end

    factory :daily_cont_second_1, class: Contract do
      term1 2
      money1 5000 
    end
  end

  factory :contract, class: Contract do
    Leaf
    contract_date "2016-05-16"
    staff_nickname "admin"
    start_month "2016-05-01"
    skip_flag false

    after(:build) do |contract|
      contract.seals.build(sealed_flag: false)
    end

    factory :contract_1, class: Contract do
      term1 1

      factory :contract_1_normal, class: Contract do
        money1 3500 
      end

      factory :contract_1_student, class: Contract do
        money1 3000 
      end

      factory :contract_1_bike, class: Contract do
        money1 5500
      end

      factory :contract_1_largebike, class: Contract do
        money1 6500
      end

      factory :contract_1_second, class: Contract do
        money1 2500 
      end
    end

    factory :contract_2, class: Contract do
      term1 1
      term2 1

      factory :contract_2_normal, class: Contract do
        money1 1800
        money2 3500 
      end

      factory :contract_2_student, class: Contract do
        money1 1500
        money2 3000 
      end

      factory :contract_2_bike, class: Contract do
        money1 2800
        money2 5500
      end

      factory :contract_2_largebike, class: Contract do
        money1 3300
        money2 6500
      end

      factory :contract_2_second, class: Contract do
        money1 1300
        money2 2500
      end
    end

    factory :contract_3, class: Contract do
      term1 3

      factory :contract_3_normal, class: Contract do
        money1 9500 
      end

      factory :contract_3_student, class: Contract do
        money1 8500 
      end

      factory :contract_3_second, class: Contract do
        money1 7500 
      end
    end

    factory :contract_6, class: Contract do
      term1 6

      factory :contract_6_normal, class: Contract do
        money1 18000 
      end

      factory :contract_6_student, class: Contract do
        money1 15800 
      end

      factory :contract_6_second, class: Contract do
        money1 15000 
      end
    end
    factory :contract_skip, class: Contract do
      term1 1
      money1 0 
      skip_flag true
    end
  end
end
