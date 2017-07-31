require 'rails_helper'

RSpec.describe CountContractsArray do
  let(:month){ Date.parse('2016/06/01') }
  let(:query){ CountContractsQuery }
  let(:params) { { month: month, query: query } } 
  let(:array) { CountContractsArray.new(params) }

  let(:empty_result) {
    { this_total: Array.new(5){0},
      prev_total: Array.new(5){0},
      next_total: Array.new(5){0},
      next_unsigned: Array.new(5){0},
      next_skip: Array.new(5){0},
      this_new: Array.new(5){0},
      next_new: Array.new(5){0} }
  }

  let(:expected_result) {
    { this_total: [1, 1, 1, 0, 1],
      prev_total: [1, 0, 1, 1, 0],
      next_total: [2, 0, 0, 1, 1],
      next_unsigned: [0, 1, 0, 0, 1],
      next_skip: [0, 0, 1, 0, 0],
      this_new: [0, 1, 0, 0, 1],
      next_new: [1, 0, 0, 0, 1] }
  }

  describe 'initialize' do
    subject { array }
    it "sets input month as @month" do
      expect(subject.instance_variable_get(:@month)).to eq(month)
    end
    it "sets input query as @query" do
      expect(subject.instance_variable_get(:@query)).to eq(query)
    end
  end

  describe 'instance method' do
    subject { array }
    it 'respond to expected messages.' do
      is_expected.to respond_to(:count_contracts)
    end
  end

  context 'with no contracts at that month' do
    describe 'count_contracts' do
      subject { array.count_contracts }
      it 'returns empty hash.' do
        is_expected.to eq(empty_result)
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

    describe 'count_contracts' do
      subject { array.count_contracts }
      it 'returns expected hash.' do
        is_expected.to eq(expected_result)
      end
    end
  end
end
