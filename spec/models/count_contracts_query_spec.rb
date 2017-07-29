require 'rails_helper'

RSpec.describe CountContractsQuery do
  let(:month) { Date.parse('2016/06/01') }

  describe 'class method' do
    subject { CountContractsQuery }
    it 'respond to expected messages.' do
      is_expected.to respond_to(:count_present_contracts)
      is_expected.to respond_to(:count_new_contracts)
      is_expected.to respond_to(:count_next_skip_contracts)
      is_expected.to respond_to(:count_next_unsigned_contracts)
    end
  end

  context 'with no contracts at that month' do
    describe 'self.count_present_contracts' do
      subject { CountContractsQuery.count_present_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_new_contracts' do
      subject { CountContractsQuery.count_new_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_next_skip_contracts' do
      subject { CountContractsQuery.count_next_skip_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_next_unsigned_contracts' do
      subject { CountContractsQuery.count_next_unsigned_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
  end

  context 'with some contracts at that month' do

    before(:all) do
      create(:count_first_normal_1) 
      create(:count_first_normal_2) 
      create(:count_first_normal_3) 
      create(:count_first_student_1) 
      create(:count_bike_1) 
      create(:count_largebike_1) 
      create(:count_second_1) 
      create(:count_second_2) 
    end

    describe 'self.count_present_contracts' do
      subject { CountContractsQuery.count_present_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({
          [1, false, false]=>1,
          [1, true, false]=>1,
          [2, false, false]=>1,
          [3, false, false]=>1
        })
      end
    end
    describe 'self.count_new_contracts' do
      subject { CountContractsQuery.count_new_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [1, true, false]=>1, [3, false, false]=>1 })
      end
    end
    describe 'self.count_next_skip_contracts' do
      subject { CountContractsQuery.count_next_skip_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [2, false, false]=>1 })
      end
    end
    describe 'self.count_next_unsigned_contracts' do
      subject { CountContractsQuery.count_next_unsigned_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [1, true, false]=>1, [3, false, false]=>1 })
      end
    end
  end

=begin
  describe "Count_contracts_query" do
    context 'with no contracts around the month' do
      it "counts results are all 0." do

        expected_hash = {
          "present_total" => [0, 0, 0, 0, 0, 0, 0],
          "present_new"   => [0, 0, 0, 0, 0, 0, 0],
          "next_total"    => [0, 0, 0, 0, 0, 0, 0],
          "next_new"      => [0, 0, 0, 0, 0, 0, 0],
          "diffs_prev"    => [0, 0, 0, 0, 0, 0, 0],
          "next_unsigned"   => [0, 0, 0, 0, 0, 0, 0]
        }


        month = Date.parse("2016-01-01")
        summary = CountContractsSummary.new(month)
        counts = summary.count_contracts_summary()
        expect(counts).to eq(expected_hash)
      end
    end

    context 'with some contracts around the month', focus: true do

      let(:count_first_normal_1){ create(:count_first_normal_1) }
      let(:count_first_normal_2){ create(:count_first_normal_2) }
      let(:count_first_normal_3){ create(:count_first_normal_3) }
      let(:count_first_student_1){ create(:count_first_student_1) }
      let(:count_bike_1){ create(:count_bike_1) }
      let(:count_largebike_1){ create(:count_largebike_1) }
      let(:count_second_1){ create(:count_second_1) }
      let(:count_second_2){ create(:count_second_2) }

      before{
        # leafs(contain customers and contracts)
        count_first_normal_1
        count_first_normal_2
        count_first_normal_3
        count_first_student_1
        count_bike_1
        count_largebike_1
        count_second_1
        count_second_2
        #p Contract.where("skip_flag = ? and start_month > ?", true, '2016-06-30')
        p Leaf.where("last_date < ?", '2016-07-01').group(:vhiecle_type, :student_flag, :largebike_flag).count
      }

      it "counts results are as expected." do

        expected_hash = {
          "present_total" => [1, 1, 2, 1, 0, 1, 1],
          "present_new"   => [0, 1, 1, 0, 0, 0, 1],
          "next_total"    => [2, 0, 2, 0, 1, 1, 1],
          "next_new"      => [1, 0, 1, 0, 0, 0, 1],
          "diffs_prev"    => [0, 1, 1, 0, -1, -1, 1],
          "next_unsigned"   => [0, 1, 1, 1, 0, 1, 1]
        }

        month = Date.parse("2016-06-01")
        summary = CountContractsSummary.new(month)
        counts = summary.count_contracts_summary()
        expect(counts).to eq(expected_hash)
      end
    end
  end
=end
end
