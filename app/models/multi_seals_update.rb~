class MultiSealsUpdate
  include ActiveModel::Model
  include StaffsExist

  attr_accessor :sealed_date
  attr_accessor :sealsid_list
  attr_accessor :staff_nickname

  date_format = /\A20[0-9]{2}(\/|-)(0[1-9]|1[0-2])(\/|-)(0[1-9]|(1|2)[0-9]|3[01])\z/
  
  # All parameters are required for update action.
  validates :sealed_date, 
    presence: true,
    format: { with: date_format, allow_blank: true}
  validate :isValidArray?
  validate :staffExists?

  def updateSelectedSeals
    # Check all params exist.
    return false if self.invalid?

    ids = self.sealsid_list

    attributes = Array.new(
      ids.size,
      {
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

    # RecordNotFound exception raised with unexist id
    rescue ActiveRecord::RecordNotFound => e
      errors.add(:sealsid_list, '存在しないシール情報です。')
      return false
  end

  private
  # If no number is selected, [""] array is sent from client.
  def isValidArray?
    sealsid_list = self.sealsid_list

    if !sealsid_list.is_a?(Array) || !sealsid_list.all?{|id| id =~ /^\d+/} 
      errors.add(:sealsid_list, 'は不正な形式です')
      return false
    elsif sealsid_list.empty?
      errors.add(:sealsid_list, 'が選択されていません。')
      return false
    end
  end
end
