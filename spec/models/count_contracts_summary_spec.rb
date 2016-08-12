require 'rails_helper'

RSpec.describe CountContractsSummary, type: :model do

  describe "Count_contracts_summary" do
    context "with month" do
      ['2000/01/01', '2000-01-01', '2099/12/31'].each do |value|
        context "#{value}" do
          month = Date.parse(value)
          summary = CountContractsSummary.new(month)

          it "is valid." do
            expect(summary).to be_valid
          end

          it "sets entered date as month." do
            expect(summary.month).to eq(month)
          end
        end
      end
  
      context 'with nil' do
        it "sets current date as month." do
          summary = CountContractsSummary.new(nil)
          expect(summary.month).
            to eq(Date.today)
        end
      end
  
      ['1999/12/31', '2100/01/01'].each do |value|
        context "#{value}" do
          date = Date.parse(value)
          summary = CountContractsSummary.new(date)

          it "is invalid." do
            expect(summary).not_to be_valid
          end

          it "returns error messages. " do
            expect(summary.errors[:month]).to be_present
          end
        end
      end

      [0, true, 'a', 'あ'].each do |value|
        context "#{value}" do
          summary = CountContractsSummary.new(value)
          it "is invalid." do
            expect(summary).not_to be_valid
          end

          it "returns error messages. " do
            expect(summary.errors[:month]).to be_present
          end
        end
      end
    end

    context 'with no contracts around the month' do
      it "counts results are all 0." do

        expected_hash = {
          "present_total" => [0, 0, 0, 0, 0, 0, 0],
          "present_new"   => [0, 0, 0, 0, 0, 0, 0],
          "next_total"    => [0, 0, 0, 0, 0, 0, 0],
          "next_new"      => [0, 0, 0, 0, 0, 0, 0],
          "diffs_prev"    => [0, 0, 0, 0, 0, 0, 0],
          "next_unpaid"   => [0, 0, 0, 0, 0, 0, 0]
        }


        month = Date.parse("2016-01-01")
        summary = CountContractsSummary.new(month)
        counts = summary.countContractsSummary()
        expect(counts).to eq(expected_hash)
      end
    end

    context 'with some contracts around the month' do

      let(:count_first_normal_1){ create(:count_first_normal_1) }
      let(:count_first_normal_2){ create(:count_first_normal_2) }
      let(:count_first_normal_3){ create(:count_first_normal_3) }
      let(:count_first_student_1){ create(:count_first_student_1) }
      let(:count_bike_1){ create(:count_bike_1) }
      let(:count_largebike_1){ create(:count_largebike_1) }
      let(:count_second_1){ create(:count_second_1) }
      let(:count_second_2){ create(:count_second_2) }

      before{
        # staff
        create(:admin)
        # leafs(contain customers and contracts)
        count_first_normal_1
        count_first_normal_2
        count_first_normal_3
        count_first_student_1
        count_bike_1
        count_largebike_1
        count_second_1
        count_second_2
      }

      it "counts results are as expected." do

        expected_hash = {
          "present_total" => [1, 1, 2, 1, 0, 1, 1],
          "present_new"   => [0, 1, 1, 0, 0, 0, 1],
          "next_total"    => [2, 0, 2, 0, 1, 1, 1],
          "next_new"      => [1, 0, 1, 0, 0, 0, 1],
          "diffs_prev"    => [0, 1, 1, 0, -1, -1, 1],
          "next_unpaid"   => [0, 1, 1, 1, 0, 1, 1]
        }

        month = Date.parse("2016-06-01")
        summary = CountContractsSummary.new(month)
        counts = summary.countContractsSummary()
        expect(counts).to eq(expected_hash)
      end
    end
  end
end