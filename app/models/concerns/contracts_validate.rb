require 'active_support'

# Modlue for validating contract model.
module ContractsValidate
  extend ActiveSupport::Concern

  # Seal's month must be unique in the leaf.
  def month_exists?
    months = seals.map(&:month)

    if Contract.joins(:seals)
               .where('leaf_id = ? and seals.month in ( ? )', leaf_id, months)
               .exists?
      errors.add(:month, 'は既に契約済みです。')
      return false
    end
  end

  # Terms length must not be changed after create!
  # Because this change causes empty terms in the leaf.
  def same_length_terms?
    if term1_changed? || term2_changed?
      errors.add(:term1, '期間の変更はできません。')
      return false
    end
  end

  # Only the last contract is allowed to be deleted!
  def last_contract?
    if id != leaf.contracts.last.id
      errors.add(:start_month, '最後尾以外の契約は削除できません。')
      return false
    end
  end
end
