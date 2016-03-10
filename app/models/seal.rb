class Seal < ActiveRecord::Base
  belongs_to :contract

  validates :month,
    presence: true,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, allow_blank: true}
  validates :sealed_flag,
    inclusion: {in: [true, false]}
  validates :sealed_date,
    format: { if: 'sealed_flag', with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/ }
  validates :staff_nickname,
    presence: { if: 'sealed_flag' },
    length: { maximum: 10, allow_blank: true }
end
