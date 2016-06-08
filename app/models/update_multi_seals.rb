class UpdateMultiSeals
  include ActiveModel::Model

  attr_accessor :sealed_date
  attr_accessor :numbers_sealsid_list
  attr_accessor :staff_nickname

  date_format = /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/
  
  # All parameters are required for update action.
  validates :sealed_date, 
    presence: true,
    format: { with: date_format, allow_blank: true}
  validates :numbers_sealsid_list,
    presence: true
  validate :isBlankArray?
  validate :staffExists?

  def updateSelectedSeals
    # Check all params exist.
    return false if self.invalid?

    ids = self.numbers_sealsid_list
    
    # List contains "" value in the end.
    # As this causes exception, it needs to be removed!
    ids.pop if ids.last == ""

    attributes = Array.new(ids.size, {
                   sealed_flag: true,
                   sealed_date: self.sealed_date,
                   staff_nickname: self.staff_nickname
                 }
               )

    # If unexist id is contained, all update is cancelled
    Seal.transaction do
      Seal.update(ids, attributes)
    end

    # Successed all update, return true
    return true

    # RecordNotFound exception raised with non exist id
    rescue ActiveRecord::RecordNotFound => e
      errors.add(:numbers_sealsid_list, '存在しないシール情報です。')
      return false
  end

  private
  # staff_nickname must exist in StaffDB.
  def staffExists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
  end
  
  # If no number is selected, [""] array is sent from client.
  def isBlankArray?
    if self.numbers_sealsid_list.blank? || self.numbers_sealsid_list[0] == ""
      errors.add(:numbers_sealsid_list, 'が選択されていません。')
      return false
    end
  end
end
