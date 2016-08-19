FactoryGirl.define do
  factory :admindetail, class: Staffdetail do
    Staff
    name "管理者ユーザ"
    read "カンリシャユーザ"
    address "寝屋川市"
    birthday "2012-03-01"
    phone_number "072-838-2058"
    cell_number "090-0000-0000"
  end

  factory :normaldetail, class: Staffdetail do
    Staff
    name "一般ユーザ"
    read "イッパンユーザ"
    address "寝屋川市"
    birthday "2013-04-01"
    phone_number "072-999-7777"
    cell_number "090-4567-8901"
  end
end
