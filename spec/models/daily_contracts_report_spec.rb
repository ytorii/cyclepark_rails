require 'rails_helper'

RSpec.describe DailyContractsReport, type: :model do

  describe 'attribute' do
    it { is_expected.to respond_to :contracts_date }
    it { is_expected.to respond_to :contracts_date= }
  end

  describe 'validation' do
    describe '#contract_date' do
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').for(:contracts_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:contracts_date) }
      it { is_expected.not_to allow_value(nil, 0, true, 'a', 'あ').for(:contracts_date) }
    end
  end

  describe 'method' do
    let(:date){ '2001/01/01' }
    let(:query) { double('DailyContractsQuery') }
    let(:params){ { contracts_date: date, query: query } }

    let(:total_list) { [ [2, 28500], [2, 14800], [1, 5000] ] }
    let(:total_result) { [ [5, 48300], [2, 28500], [2, 14800], [1, 5000] ] }
    let(:blank_result) { [ [0, 0], [0, 0], [0, 0], [0, 0] ] } 

    before {
      allow(query).to receive(:list_each_contract).with(date)
      allow(query).
        to receive(:list_each_vhiecle_type).with(date).and_return(total_list)
    }

    describe '.initialize' do
      subject{ DailyContractsReport.new(params) }

      context 'with nil contract_date input' do
        before{ params[:contracts_date] = nil }
        it 'sets current date as @contracts_date' do
          expect(subject.contracts_date).to eq(Date.current)
        end
      end

      context 'with not nil contract_date input' do
        it "sets input as @contracts_date" do
          expect(subject.contracts_date).to eq(date)
        end
      end

      it "sets input query as @query" do
        expect(subject.instance_variable_get(:@query)).to eq(query)
      end
    end

    describe '.contracts_list' do
      it 'calls query.list_each_contract once with input date' do
        expect(query).to receive(:list_each_contract).with(date)
        DailyContractsReport.new(params).contracts_list 
      end
    end

    describe '.contracts_total' do
      subject{ DailyContractsReport.new(params).contracts_total }
      it 'calls query.list_each_vhiecle_type once with input date' do
        expect(query).to receive(:list_each_vhiecle_type).with(date)
        subject
      end

      context 'with no contracts at that day' do
        before {
          allow(query).
            to receive(:list_each_vhiecle_type).with(date).and_return([])
        }
        it 'returns all 0 array.' do
          is_expected.to eq(blank_result)
        end
      end

      context 'with some contracts at that day' do
        it 'returns array with total amount of count and money.' do
          is_expected.to eq(total_result)
        end
      end
    end
  end
end
