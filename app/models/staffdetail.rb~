require 'nkf'

# Model for staff data, like name, address, phone number
class Staffdetail < ActiveRecord::Base
  belongs_to :staff

  kana_format = /\A[\p{Katakana}\u30fc\p{blank}]+\z/
  date_format = %r(\A(19|20)[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)
  cell_format = /\A[0-9]{3}-[0-9]{4}-[0-9]{4}\z/

  validates :name,
            presence: true,
            length: { maximum: 20, allow_blank: true }
  validates :read,
            presence: true,
            format: { with: kana_format, allow_blank: true },
            length: { maximum: 40, allow_blank: true }
  validates :address,
            presence: true,
            length: { maximum: 50, allow_blank: true }
  validates :birthday,
            presence: true,
            format: { with: date_format, allow_blank: true }
  validates :phone_number,
            presence: { if: 'cell_number.blank?' },
            format: { with: /\A([0-9]|-)+\z/, allow_blank: true },
            length: { maximum: 12, allow_blank: true }
  validates :cell_number,
            presence: { if: 'phone_number.blank?', allow_blank: true },
            format: { with: cell_format, allow_blank: true }

  before_validation do
    self.read = NKF.nkf('-wh2', read) if read
  end
end
