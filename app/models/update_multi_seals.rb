class UpdateMultiSeals
  include ActiveModel::Model

  attr_accessor :sealed_date
  attr_accessor :numbers_sealsid_list
  attr_accessor :staff_nickname

  # All parameters are required for update action.
  validates :sealed_date, 
    presence: true
  validates :numbers_sealsid_list,
    presence: true
  validate :isBlankArray?
  validate :staffExists?

  private
  # staff_nickname must exist in StaffDB.
  def staffExists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
  end
  
  # If no number is selected, [""] array is sent from client.
  def isBlankArray?
    if self.numbers_sealsid_list[0] == ""
      errors.add(:numbers_sealsid_list, 'が選択されていません。')
      return false
    end
  end
end
