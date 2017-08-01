require 'rails_helper'

RSpec.describe CountContractsSummary, type: :model do
  let(:month){ '2016/06/11' }
  let(:summary){ CountContractsSummary.new(month) }
  subject{ summary }

  describe 'attribute' do
    it { is_expected.to respond_to :month }
    it { is_expected.to respond_to :month= }
  end

  describe 'method' do
    describe '.initialize' do
      context 'with not nil input' do
        it "sets input month as @month" do
          expect(summary.month).to eq(Date.parse(month))
        end
      end
      context 'with nil input' do
        it "sets current date as @query" do
          expect(CountContractsSummary.new(nil).month).to eq(Date.current)
        end
      end
    end

    describe '.report_summary' do
      let(:array){ double('CountContractsArray') }
      let(:empty_counts) {
        { this_total: Array.new(5){0},
          prev_total: Array.new(5){0},
          next_total: Array.new(5){0},
          next_unsigned: Array.new(5){0},
          next_skip: Array.new(5){0},
          this_new: Array.new(5){0},
          next_new: Array.new(5){0} }
      }

      let(:empty_summary){
        { present_total: [0, 0, 0, 0, 0, 0, 0],
          present_new:   [0, 0, 0, 0, 0, 0, 0],
          next_total:    [0, 0, 0, 0, 0, 0, 0],
          next_new:      [0, 0, 0, 0, 0, 0, 0],
          diffs_prev:    [0, 0, 0, 0, 0, 0, 0],
          next_unpaid:   [0, 0, 0, 0, 0, 0, 0] }
      }

      let(:expected_counts) {
        { this_total:    [1, 1, 1, 0, 1],
          prev_total:    [1, 0, 1, 1, 0],
          next_total:    [2, 0, 0, 1, 1],
          next_unsigned: [0, 1, 0, 0, 1],
          next_skip:     [0, 0, 1, 0, 0],
          this_new:      [0, 1, 0, 0, 1],
          next_new:      [1, 0, 0, 0, 1] }
      }

      let(:expected_summary){
        { present_total: [1, 1, 2, 1, 0, 1, 1],
          present_new:   [0, 1, 1, 0, 0, 0, 1],
          next_total:    [2, 0, 2, 0, 1, 1, 1],
          next_new:      [1, 0, 1, 0, 0, 0, 1],
          diffs_prev:    [0, 1, 1, 0, -1, -1, 1],
          next_unpaid:   [0, 1, 1, 1, 0, 1, 1] }
      }

      before{ allow(summary).to receive(:counts_array).and_return(array) }

      subject{ summary.report_summary }

      context 'with no contracts around the month' do
        before{
          allow(array).to receive(:count_contracts).and_return(empty_counts)
        }

        it "count results are all 0." do
          is_expected.to eq(empty_summary)
        end
      end

      context 'with some contracts around the month' do
        before{
          allow(array).to receive(:count_contracts).and_return(expected_counts)
        }

        it "counts results are as expected." do
          is_expected.to eq(expected_summary)
        end
      end
    end
  end
end
