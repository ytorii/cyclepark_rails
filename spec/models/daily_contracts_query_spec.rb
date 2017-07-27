require 'rails_helper'

RSpec.describe DailyContractsReport, type: :model do

  describe 'attribute' do
    it { is_expected.to respond_to :contracts_date }
    it { is_expected.to respond_to :contracts_date= }
  end

  describe 'validation' do
    describe '#contract_date' do
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').  for(:contracts_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').  for(:contracts_date) }
      it { is_expected.not_to allow_value(nil, 0, true, 'a', 'あ').  for(:contracts_date) }
    end
  end

  describe 'method' do
    describe '.initialize' do
      let(:query) { DailyContractsQuery }
      let(:params){ { contracts_date: nil, query: query } }
      subject{ DailyContractsReport.new(params) }

      context 'with nil contract_date input' do
        it 'sets current date as @contracts_date' do
          expect(subject.contracts_date).to eq(Date.current)
        end
      end

      context 'with not nil contract_date input' do
        let(:date){ '2001/01/01' }
        before{ params[:contracts_date] = date }
        it "sets input as @contracts_date" do
          expect(subject.contracts_date).to eq(date)
        end
      end

      it "sets input query as @query" do
        expect(subject.instance_variable_get(:@query)).to eq(query)
      end
    end

    describe '.contracts_list' do
      subject{}

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
