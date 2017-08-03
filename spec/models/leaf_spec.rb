require 'rails_helper'

RSpec.describe Leaf, type: :model do
  let(:first){ build(:first, number: 1) }

  describe 'validation' do
    describe '#vhiecle_type' do
      it { is_expected.to validate_presence_of(:vhiecle_type) }
      it { is_expected.to validate_numericality_of(:vhiecle_type).
           is_greater_than_or_equal_to(1).
           is_less_than_or_equal_to(3).
           only_integer.allow_nil }
    end

    describe "number" do
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to validate_numericality_of(:number).
           is_greater_than_or_equal_to(1).
           is_less_than_or_equal_to(1056).
           only_integer.allow_nil }
    end

    describe '#student_flag' do
      it { is_expected.to validate_inclusion_of(:student_flag).in_array([true, false])}
    end

    describe '#largebike_flag' do
      it { is_expected.to validate_inclusion_of(:largebike_flag).in_array([true, false])}
    end

    describe '#valid_flag' do
      it { is_expected.to validate_inclusion_of(:valid_flag).in_array([true, false])}
    end

    describe '#start_date' do
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').for(:start_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:start_date) }
      it { is_expected.not_to allow_value(nil, 0, true, 'a', 'あ').for(:start_date) }
    end

    describe '#last_date' do
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').for(:last_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:last_date) }
      it { is_expected.not_to allow_value(0, true).for(:last_date) }
    end
  end

  describe "Number in the same vhiecle_type" do
    let(:bike){ create(:bike, number: 1) }
    let(:second){ create(:second, number: 1) }

    context "with valid leafs" do
      before{
        first.save!
        bike
        second
      }

      context "when number doesn't exist in valid leafs" do
        it "is valid." do
          first_add = build(:first, number: 2)
          expect(first_add).to be_valid
        end
      end

      context "when number already exists in valid leafs" do
        it "is invalid." do
          first_add = build(:first, number: 1)
          expect(first_add).not_to be_valid
          expect(first_add.errors[:number]).to be_present
        end
      end
    end

    context "with cancelled leafs" do
      before{
        first.valid_flag = false
        first.save!
        second
        bike
      }

      context "when valid number already exists in cancelled leafs" do
        subject{ build( :first, number: 1 ) }
        it "is valid." do
          is_expected.to be_valid
        end
      end

      context "when cancelled number already exists in cancelled leafs" do
        subject{ build(:first, number: 1, valid_flag: false) }
        it "is valid." do
          is_expected.to be_valid
        end
      end
    end
  end
end
