require 'rails_helper'

RSpec.describe CountContractsQuery do
  let(:month) { Date.parse('2016/06/01') }
  let(:count_contracts_query){ CountContractsQuery }

  describe 'method' do
    subject { count_contracts_query }
    it 'respond to expected messages.' do
      is_expected.to respond_to(:count_total_contracts)
      is_expected.to respond_to(:count_new_contracts)
      is_expected.to respond_to(:count_next_skip_contracts)
      is_expected.to respond_to(:count_next_unsigned_contracts)
    end
  end

  context 'with no contracts at that month' do
    describe 'self.count_total_contracts' do
      subject { count_contracts_query.count_total_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_new_contracts' do
      subject { count_contracts_query.count_new_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_next_skip_contracts' do
      subject { count_contracts_query.count_next_skip_contracts(month) }
      it 'returns empty hash.' do
        is_expected.to eq({})
      end
    end
    describe 'self.count_next_unsigned_contracts' do
      subject { count_contracts_query.count_next_unsigned_contracts(month) }
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

    describe 'self.count_total_contracts' do
      subject { count_contracts_query.count_total_contracts(month) }
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
      subject { count_contracts_query.count_new_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [1, true, false]=>1, [3, false, false]=>1 })
      end
    end
    describe 'self.count_next_skip_contracts' do
      subject { count_contracts_query.count_next_skip_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [2, false, false]=>1 })
      end
    end
    describe 'self.count_next_unsigned_contracts' do
      subject { count_contracts_query.count_next_unsigned_contracts(month) }
      it 'returns expected hash.' do
        is_expected.to eq({ [1, true, false]=>1, [3, false, false]=>1 })
      end
    end
  end
end
