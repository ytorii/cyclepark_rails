# Model for updating multiple seals.
class MultiSealsUpdate
  include ActiveModel::Model
  include StaffsExist

  attr_accessor :sealed_date
  attr_accessor :sealsid_list
  attr_accessor :staff_nickname

  date_format =
    %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])(/|-)(0[1-9]|(1|2)[0-9]|3[01])\z)

  # All parameters are required for update action.
  validates :sealed_date,
            presence: true,
            format: { with: date_format, allow_blank: true }
  validate :valid_array?
  validate :staff_exists?

  def update_selected_seals
    # Check all params exist.
    return false if invalid?

    # If unexist id is contained, all update is cancelled
    Seal.transaction do
      Seal.update(sealsid_list, set_seals_attributes)
    end

    # Successed all update, return true
    true
  end

  private

  # If no number is selected, [""] array is sent from client.
  def valid_array?
    sealsid_list = self.sealsid_list

    if !sealsid_list.is_a?(Array) || !sealsid_list.all? { |id| id =~ /^\d+/ }
      errors.add(:sealsid_list, 'は不正な形式です')
      return false
    elsif sealsid_list.empty?
      errors.add(:sealsid_list, 'が選択されていません。')
      return false
    end
  end

  def set_seals_attributes
    Array.new(
      sealsid_list.size,
      sealed_flag: true,
      sealed_date: sealed_date,
      staff_nickname: staff_nickname
    )
  end
end
