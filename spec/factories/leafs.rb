FactoryGirl.define do
  factory :first, class: Leaf do
    sequence(:number) { |n| n }
    #number 1
    vhiecle_type 1
    student_flag false
    largebike_flag false
    valid_flag true
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
    sequence(:number) { |n| n }
    vhiecle_type 1
    student_flag false
    largebike_flag false
    valid_flag true
    start_date "2016-02-01"
    last_date ""

    after(:build) do |first|
      build(:first_customer_add, leaf: first)
    end
    after(:create) do |first|
      create(:first_customer_add, leaf: first)
    end
  end

  factory :student, class: Leaf do
    sequence(:number) { |n| n }
    vhiecle_type 1
    student_flag true
    largebike_flag false
    valid_flag true
    start_date "2016-04-08"
    last_date "2016-05-31"

    after(:build) do |student|
      build(:student_customer, leaf: student)
    end
    after(:create) do |student|
      create(:student_customer, leaf: student)
    end
  end

  factory :bike, class: Leaf do
    sequence(:number) { |n| n }
    vhiecle_type 2
    student_flag false
    largebike_flag false
    valid_flag true
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
    sequence(:number) { |n| n }
    vhiecle_type 2
    student_flag false
    largebike_flag true
    valid_flag true
    start_date "2016-03-01"
    last_date "2016-03-31"

    after(:build) do |large_bike|
      build(:large_bike_customer, leaf: large_bike)
    end
    after(:create) do |large_bike|
      create(:large_bike_customer, leaf: large_bike)
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
  end
end
