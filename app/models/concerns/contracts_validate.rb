require 'active_support'
module ContractsValidate
  extend ActiveSupport::Concern

  # Seal's month must be unique in the leaf.
  def month_exists?
    seals.each do |seal|
      next unless Contract.joins(:seals).where(
        'leaf_id = ? and seals.month = ?',
        leaf_id, seal.month
      ).exists?
      errors.add(:month, 'は既に契約済みです。')
      return false
    end
  end

  # Terms length must not be changed after create!
  # Because this change causes empty terms in the leaf.
  def same_length_terms?
    prev = Contract.find(id)
    unless term1 == prev.term1 && term2 == prev.term2
      errors.add(:term1, '契約期間の変更はできません。')
      return false
    end
  end

  # Only the last contract is allowed to be deleted!
  def last_contract?
    last = Leaf.find(leaf_id).contracts.last
    unless id == last.id
      errors.add(:start_month, '最後尾以外の契約は削除できません。')
      return false
    end
  end
end
