require 'active_support'
module StaffsExist
  extend ActiveSupport::Concern

  def staffExists?
    unless Staff.where(nickname: self.staff_nickname).exists?
      errors.add(:staff_nickname, 'は存在しないスタッフです。')
    end
  end

end
