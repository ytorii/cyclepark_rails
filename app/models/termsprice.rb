class Termsprice
  include ActiveModel::Model

  attr_accessor :leaf_id
  attr_accessor :term

  validates :term,
    presence: true,
    numericality: { greater_than: 0, less_than: 10, allow_blank: true }
  validate :leafExists?

  def getPrice

    leaf = getLeaf

    # First area has fixed discount prices for longer term,
    # so price list is array for terms.
    first_price = {
      false => [3500, 7000, 9500, 13000, 16500, 18000],
      true => [3000, 6000, 8500, 11500, 14500, 15800],
    }

    bike_price = {
      false => 5500,
      true => 6500
    }

    second_price = 2500

    case leaf.vhiecle_type
    when 1
      first_price[leaf.student_flag][term.to_i - 1]
    when 2
      bike_price[leaf.largebike_flag] * term.to_i
    when 3
      second_price * term.to_i
    end
  end

  private
  def getLeaf
    Leaf.find(leaf_id)
  end

  def leafExists?
    unless Leaf.exists?(leaf_id)
      errors.add(:leaf_id, 'は存在しないリーフです。')
    end
  end
end
