require 'rails_helper'

RSpec.describe DailyContractsQuery, type: :model do

  let(:date) { Date.parse('2016/01/16') }
  let(:vhiecle_type_result){ [[2, 28500], [2, 14800], [1, 5000]] }

  describe 'class method' do
    subject { DailyContractsQuery }
    it 'respond to expected messages.' do
      is_expected.to respond_to(:list_each_contract)
      is_expected.to respond_to(:list_each_vhiecle_type)
    end
  end

  context 'with no contracts at the day' do
    describe 'self.list_each_contract' do
      subject { DailyContractsQuery.list_each_contract(date) }
      it 'returns empty list.' do
        is_expected.to eq([])
      end
    end
    describe 'self.list_each_vhiecle_type' do
      subject { DailyContractsQuery.list_each_vhiecle_type(date) }
      it 'returns empty list.' do
        is_expected.to eq([])
      end
    end
  end

  context 'with some contracts at the day' do
    before do
      # leafs(contain customers and contracts)
      create(:daily_first_nrm_1) 
      create(:daily_first_std_1) 
      create(:daily_bike_1) 
      create(:daily_large_bike_1) 
      create(:daily_second_1) 
      create(:daily_first_nrm_2) 
    end

    describe 'self.list_each_contract' do
      subject { DailyContractsQuery.list_each_contract(date) }
      it 'returns expected list of each contract.' do
        leafs = Leaf.
          includes(:contracts).
          where("contracts.contract_date = ? and skip_flag = 'f'", date).
          references(:contracts)

        subject.each_with_index do |c, i|
          expect(c.number).to eq(leafs[i].number)
          expect(c.vhiecle_type).to eq(leafs[i].vhiecle_type)
          expect(c.student_flag).to eq(leafs[i].student_flag.to_s[0])
          expect(c.largebike_flag).to eq(leafs[i].largebike_flag.to_s[0])
          expect(c.first_name).to eq(leafs[i].customer.first_name)
          expect(c.last_name).to eq(leafs[i].customer.last_name)
          expect(c).to eq(leafs[i].contracts.first)
        end
      end
    end
    describe 'self.list_each_vhiecle_type' do
      subject { DailyContractsQuery.list_each_vhiecle_type(date) }
      it 'returns expected list of each vhiecle type.' do
        is_expected.to eq(vhiecle_type_result)
      end
    end
  end
end
