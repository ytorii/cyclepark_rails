FactoryGirl.define do
  factory :first_leaf, class: Leaf do
    sequence(:number) { |n| n }
    vhiecle_type 1
    largebike_flag false
    valid_flag true

    factory :first, class: Leaf do
      student_flag false
      start_date "2016-02-01"
      last_date "2016-02-29"

      after(:build) do |first|
        build(:first_customer, leaf: first)
      end
      after(:create) do |first|
        create(:first_customer, leaf: first)
      end
    end

    factory :first_add, class: Leaf do
      student_flag false
      start_date "2016-02-01"
      last_date ""

      after(:build) do |first|
        build(:first_customer, leaf: first)
      end
      after(:create) do |first|
        create(:first_customer, leaf: first)
      end
    end

    factory :student, class: Leaf do
      student_flag true
      start_date "2016-04-08"
      last_date "2016-05-31"

      after(:build) do |student|
        build(:student_customer, leaf: student)
      end
      after(:create) do |student|
        create(:student_customer, leaf: student)
      end
    end
  end

  factory :bike_leaf, class: Leaf do
    sequence(:number) { |n| n }
    vhiecle_type 2
    student_flag false
    valid_flag true

    factory :bike, class: Leaf do
      largebike_flag false
      start_date "2016-04-01"
      last_date "2016-04-30"

      after(:build) do |bike|
        build(:bike_customer, leaf: bike)
      end
      after(:create) do |bike|
        create(:bike_customer, leaf: bike)
      end
    end

    factory :large_bike, class: Leaf do
      largebike_flag true
      start_date "2016-03-01"
      last_date "2016-03-31"

      after(:build) do |large_bike|
        build(:large_bike_customer, leaf: large_bike)
      end
      after(:create) do |large_bike|
        create(:large_bike_customer, leaf: large_bike)
      end
    end
  end

  factory :second, class: Leaf do
    sequence(:number) { |n| n }
    vhiecle_type 3
    student_flag false
    largebike_flag false
    valid_flag true
    start_date "2016-04-02"
    last_date "2016-04-30"

    after(:build) do |second|
      build(:second_customer, leaf: second)
    end
    after(:create) do |second|
      create(:second_customer, leaf: second)
    end
  end

  factory :daily, class: Leaf do
    sequence(:number) { |n| n }
    start_date "2016-02-01"
    last_date "2016-02-29"
    valid_flag true

    factory :daily_first, class: Leaf do
      vhiecle_type 1
      largebike_flag false

      factory :daily_first_nrm_1, class: Leaf do
        student_flag false
        after(:create) do |leaf|
          create(:first_customer, leaf: leaf)
          create(:daily_cont_first_1, leaf: leaf)
        end
      end

      factory :daily_first_nrm_2, class: Leaf do
        student_flag false
        after(:create) do |leaf|
          create(:first_customer, leaf: leaf)
          create(:daily_cont_first_2, leaf: leaf)
        end
      end

      factory :daily_first_std_1, class: Leaf do
        student_flag true
        after(:create) do |leaf|
          create(:student_customer, leaf: leaf)
          create(:daily_cont_student_1, leaf: leaf)
        end
      end
    end

    factory :daily_bike, class: Leaf do
      vhiecle_type 2
      student_flag false

      factory :daily_bike_1, class: Leaf do
        largebike_flag false
        after(:create) do |leaf|
          create(:bike_customer, leaf: leaf)
          create(:daily_cont_bike_1, leaf: leaf)
        end
      end

      factory :daily_large_bike_1, class: Leaf do
        largebike_flag true
        after(:create) do |leaf|
          create(:large_bike_customer, leaf: leaf)
          create(:daily_cont_large_bike_1, leaf: leaf)
        end
      end
    end

    factory :daily_second, class: Leaf do
      vhiecle_type 3
      student_flag false
      largebike_flag false

      factory :daily_second_1, class: Leaf do
        after(:create) do |leaf|
          create(:second_customer, leaf: leaf)
          create(:daily_cont_second_1, leaf: leaf)
        end
      end
    end
  end

  factory :count, class: Leaf do
    month1 = Date.parse("2016-05-01")
    month2 = month1.next_month
    month3 = month2.next_month

    sequence(:number) { |n| n }
    #last_date "2016-02-29"
    valid_flag true

    factory :count_first, class: Leaf do
      vhiecle_type 1
      largebike_flag false

      factory :count_first_normal_1, class: Leaf do
        start_date month1
        student_flag false
        after(:create) do |leaf|
          create(:first_customer, leaf: leaf)
          create(:contract_3_normal, leaf: leaf, start_month: month1)
        end
      end

      factory :count_first_normal_2, class: Leaf do
        start_date month3
        student_flag false
        after(:create) do |leaf|
          create(:first_customer, leaf: leaf)
          create(:contract_1_normal, leaf: leaf, start_month: month3)
        end
      end

      factory :count_first_normal_3, class: Leaf do
        start_date month1
        student_flag false
        after(:create) do |leaf|
          create(:first_customer, leaf: leaf)
          month = month1
          3.times do
            create(:contract_skip, leaf: leaf, start_month: month)
            month = month.next_month
          end
        end
      end

      factory :count_first_student_1, class: Leaf do
        start_date month2
        student_flag true
        after(:create) do |leaf|
          create(:student_customer, leaf: leaf)
          create(:contract_1_student, leaf: leaf, start_month: month2)
        end
      end
    end

    factory :count_bike, class: Leaf do
      vhiecle_type 2
      student_flag false

      factory :count_bike_1, class: Leaf do
        start_date month1
        largebike_flag false
        after(:create) do |leaf|
          create(:bike_customer, leaf: leaf)
          month = month1
          2.times do
            create(:contract_1_bike, leaf: leaf, start_month: month)
            month = month.next_month
          end
        end
      end

      factory :count_largebike_1, class: Leaf do
        start_date month1
        largebike_flag true
        after(:create) do |leaf|
          create(:large_bike_customer, leaf: leaf)
          create(:contract_1_largebike, leaf: leaf, start_month: month1)
          create(:contract_skip, leaf: leaf, start_month: month2)
          create(:contract_1_largebike, leaf: leaf, start_month: month3)
        end
      end
    end

    factory :count_second, class: Leaf do
      vhiecle_type 3
      student_flag false
      largebike_flag false

      factory :count_second_1, class: Leaf do
        start_date month2
        after(:create) do |leaf|
          create(:second_customer, leaf: leaf)
          create(:contract_1_second, leaf: leaf, start_month: month2)
        end
      end

      factory :count_second_2, class: Leaf do
        start_date month3
        after(:create) do |leaf|
          create(:second_customer, leaf: leaf)
          create(:contract_1_second, leaf: leaf, start_month: month3)
        end
      end
    end
  end
end
