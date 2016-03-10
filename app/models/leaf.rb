class Leaf < ActiveRecord::Base
  has_one :customer, dependent: :destroy
  has_many :contracts, dependent: :destroy
  
  # This parametor is needed to use multiple models in the same form.
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :contracts

  validates :number,
    presence: true,
    numericality: { greater_than: 0, less_than: 1013, allow_blank: true }
  validates :vhiecle_type,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validates :student_flag,
    inclusion: {in: [true, false]}
  validates :largebike_flag,
    inclusion: {in: [true, false]}
  validates :valid_flag,
    inclusion: {in: [true, false]}
  validates :start_date,
    presence: true,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, allow_blank: true}
  validates :last_date,
    format: { with: /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/, unless: 'last_date.blank?'}

end
