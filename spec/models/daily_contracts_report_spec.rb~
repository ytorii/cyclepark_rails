require 'rails_helper'

RSpec.describe DailyContractsReport, type: :model do

  describe "Daily_contracts_report" do
    
    context "with contracts_date" do
      ['2000/01/01', '2000-01-01', '2099/12/31'].each do |value|
        context "#{value}" do
          date = Date.parse(value)
          report = DailyContractsReport.new(date)

          it "is valid." do
            expect(report).to be_valid
          end

          it "sets entered date as contracts_date." do
            expect(report.contracts_date).to eq(date)
          end
        end
      end
  
      context 'with nil' do
        it "sets current date as contracts date." do
          report = DailyContractsReport.new(nil)
          expect(report.contracts_date).to eq(Date.current)
        end
      end
  
      ['1999/12/31', '2100/01/01'].each do |value|
        context "#{value}" do
          date = Date.parse(value)
          report = DailyContractsReport.new(date)

          it "is invalid." do
            expect(report).not_to be_valid
          end

          it "returns error messages. " do
            expect(report.errors[:contracts_date]).to be_present
          end
        end
      end

      [0, true, 'a', 'あ'].each do |value|
        context "#{value}" do
          report = DailyContractsReport.new(value)
          it "is invalid." do
            expect(report).not_to be_valid
          end

          it "returns error messages. " do
            expect(report.errors[:contracts_date]).to be_present
          end
        end
      end
    end

    context 'with no contracts at the day' do
      date = Date.parse("2016-04-16")
      report = DailyContractsReport.new(date)

      it "has 0 size contracts_list." do
        expect(report.getContractsList().size).to eq(0)
      end

      it "has all 0 amount contracts_total." do
        amount_array = [[0, 0], [0, 0], [0, 0], [0, 0]]
        expect(report.calcContractsSummary()).to eq(amount_array)
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

      before{
        # staff
        create(:admin)
        # leafs(contain customers and contracts)
        daily_first_nrm_1
        daily_first_std_1
        daily_bike_1
        daily_large_bike_1
        daily_second_1
        daily_first_nrm_2
      }

      it "has expected size of contracts_list." do
        expect(report.getContractsList().size).to eq(5)
      end

      it "has expected contents of contracts_list." do
        leaf_array = [
          daily_first_nrm_1,
          daily_first_std_1,
          daily_bike_1,
          daily_large_bike_1,
          daily_second_1
        ]

        list_array = report.getContractsList()

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
        expect(report.calcContractsSummary()).to eq(amount_array)
      end
    end
  end
end
