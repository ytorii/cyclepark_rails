# Model for contracts' seals
class Seal < ActiveRecord::Base
  belongs_to :contract, inverse_of: :seals

  date_regexp =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  validates :month,
            presence: true,
            format: { with: date_regexp, allow_blank: true }
            #uniqueness: { scope: [:contract] }
  validates :sealed_flag,
            inclusion: { in: [true, false] }
  validates :sealed_date,
            format: { if: 'sealed_flag', with: date_regexp }
  validates :staff_nickname,
            presence: { if: 'sealed_flag' },
            length: { maximum: 10, allow_blank: true }
end
