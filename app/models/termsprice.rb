# Model for gettting money for each contract
class Termsprice
  include ActiveModel::Model

  attr_accessor :leaf_id
  attr_accessor :term

  validates :term,
            presence: true,
            numericality: {
              greater_than: 0,
              less_than: 13,
              only_integer: true,
              allow_blank: true
            }

  validate :leaf_exists?

  def calc_price
    @leaf = Leaf.find(leaf_id)
    @term = term

    case @leaf.vhiecle_type
    when 1
      calc_first_price
    when 2
      calc_bike_price
    when 3
      calc_second_price
    end
  end

  private

  def leaf_exists?
    errors.add(:leaf_id, 'は存在しないリーフです。') unless Leaf.exists?(leaf_id)
  end

  def calc_first_price
    # First area has fixed discount prices for longer term,
    # so price list is array for terms.
    first_price = {
      false => [3500, 7000, 9500, 13_000, 16_500, 18_000],
      true => [3000, 6000, 8500, 11_500, 14_500, 15_800]
    }

    first_price[@leaf.student_flag][@term.to_i - 1]
  end

  def calc_bike_price
    bike_price = {
      false => 5500,
      true => 6500
    }

    bike_price[@leaf.largebike_flag] * @term.to_i
  end

  def calc_second_price
    2500 * @term.to_i
  end
end
