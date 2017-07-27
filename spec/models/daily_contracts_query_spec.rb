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
    before :all do
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

=begin
    describe "Daily_contracts_report" do
      context 'with no contracts at the day' do
        date = Date.parse("2016-04-16")
        report = DailyContractsReport.new(date)

        it "has 0 size contracts_list." do
          expect(report.contracts_list().size).to eq(0)
        end

        it "has all 0 amount contracts_total." do
          amount_array = [[0, 0], [0, 0], [0, 0], [0, 0]]
          expect(report.contracts_total()).to eq(amount_array)
        end
      end

      context 'with some contracts at the day' do

        let(:daily_first_nrm_1){ create(:daily_first_nrm_1) }
        let(:daily_first_std_1){ create(:daily_first_std_1) }
        let(:daily_bike_1){ create(:daily_bike_1) }
        let(:daily_large_bike_1){ create(:daily_large_bike_1) }
        let(:daily_second_1){ create(:daily_second_1) }
        let(:daily_first_nrm_2){ create(:daily_first_nrm_2) }
        let(:report){DailyContractsReport.new(Date.parse("2016-01-16"))}

        before :all do
          # leafs(contain customers and contracts)
          create(:daily_first_nrm_1) 
          create(:daily_first_std_1) 
          create(:daily_bike_1) 
          create(:daily_large_bike_1) 
          create(:daily_second_1) 
          create(:daily_first_nrm_2) 
        end

        it "has expected size of contracts_list." do
          expect(report.contracts_list().size).to eq(5)
        end

        it "has expected contents of contracts_list." do
          leaf_array = []
          1.upto(5) do |i|
            leaf_array << Leaf.find(i)
          end

          list_array = report.contracts_list()

          0.upto(4) do |i|
            expect(leaf_array[i].number).to eq(list_array[i].number)
            expect(leaf_array[i].vhiecle_type).
              to eq(list_array[i].vhiecle_type)
            # In sqlite3, boolean is "f" or "t",
            # so get first charactor of boolean value.
            expect(leaf_array[i].largebike_flag.to_s[0]).
              to eq(list_array[i].largebike_flag)
            expect(leaf_array[i].student_flag.to_s[0]).
              to eq(list_array[i].student_flag)
            expect(leaf_array[i].customer.first_name).
              to eq(list_array[i].first_name)
            expect(leaf_array[i].customer.last_name).
              to eq(list_array[i].last_name)
            expect(leaf_array[i].contracts.first).to eq(list_array[i])
          end
        end

        it "has expected amount contracts_total." do
          amount_array = [[5, 48300], [2, 28500], [2, 14800], [1, 5000]]
          expect(report.contracts_total()).to eq(amount_array)
        end
      end
    end
=end
end
