# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Staff.create(
  nickname: "admin",
  password:"12345678",
  admin_flag: true,
  staffdetail_attributes: {
    name: "管理者　ユーザ",
    read: "かんりしゃ　ゆーざ",
    address: "寝屋川市八坂町１７－１",
    birthday: '1978/01/01',
    phone_number: "000-777-8888",
    cell_number: "090-0000-1111"
  }
)
