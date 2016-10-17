require 'rails_helper'

RSpec.describe Leaf, type: :model do
  let(:first){ build(:first) }

  describe 'Number' do
    context 'is valid' do
      [1, 1056].each do |value|
        it "with #{value}." do
          first[:number] = value
          expect(first).to be_valid
        end
      end
    end

    context 'is invalid' do
      [0, 1057, 'a', 'あ'].each do |value|
        it "with #{value}." do
          first[:number] = value
          expect(first).not_to be_valid
          expect(first.errors[:number]).to be_present
        end
      end
    end
  end

  describe 'Vhiecle Type' do
    context 'is valid' do
      [1, 9].each do |value|
        it "with #{value}." do
          first[:vhiecle_type] = value
          expect(first).to be_valid
        end
      end
    end

    context 'is invalid' do
      [0, 10, 'a', 'あ'].each do |value|
        it "with #{value}." do
          first[:vhiecle_type] = value
          expect(first).not_to be_valid
          expect(first.errors[:vhiecle_type]).to be_present
        end
      end
    end
  end

  describe 'Student flag' do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first[:student_flag] = value
          expect(first).to be_valid
        end
      end
    end

    context 'is invalid' do
      [''].each do |value|
        it "with empty." do
          first[:student_flag] = value
          expect(first).not_to be_valid
          expect(first.errors[:student_flag]).to be_present
        end
      end
    end
  end

  describe 'Large Bike flag' do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first[:largebike_flag] = value
          expect(first).to be_valid
        end
      end
    end
  end

  describe 'Valid flag' do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first[:valid_flag] = value
          expect(first).to be_valid
        end
      end
    end
  end

  describe 'Start Date' do
    context 'is valid' do
      ['2000/01/01', '2000-01-01', '2099/12/31'].each do |value|
        it "with #{value}." do
          first[:start_date] = value
          expect(first).to be_valid
        end
      end
    end

    context 'is invalid' do
      ['1999/12/31', '2100/01/01'].each do |value|
        it "with #{value}." do
          first[:start_date] = value
          expect(first).not_to be_valid
          expect(first.errors[:start_date]).to be_present
        end
      end
    end
  end

  describe 'Last Date' do
    context 'is valid' do
      ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
        it "with #{value}." do
          first[:last_date] = value
          expect(first).to be_valid
        end
      end
    end

    context 'is invalid' do
      ['1999/12/31', '2100/01/01'].each do |value|
        it "with #{value}." do
          first[:last_date] = value
          expect(first).not_to be_valid
          expect(first.errors[:last_date]).to be_present
        end
      end
    end
  end

  describe "Number in the same vhiecle_type" do
    let(:bike){ create(:bike, number: 1) }
    let(:second){ create(:second, number: 1) }

    context "with effective leafs" do
      before{
        # As first's number is sequencial,
        # we need to specify the number here!
        first.number = 1
        first.save!
        bike
        second
      }

      context "when number doesn't exist in effective leafs" do
        it "is valid." do
          first_add = build(:first, number: 2)
          expect(first_add).to be_valid
        end
      end

      context "when number already exists in effective leafs" do
        it "is invalid." do
          first_add = build(:first, number: 1)
          expect(first_add).not_to be_valid
          expect(first_add.errors[:number]).to be_present
        end
      end
    end

    context "with cancelled leafs" do
      before{
        first.number = 1
        first.valid_flag = false
        first.save!
        second
        bike
      }

      context "when effective number already exists in concelled leafs" do
        it "is valid." do
          first_add = build( :first, number: 1 )
          expect(first_add).to be_valid
        end
      end

      context "when cancelled number already exists in cancelled leafs" do
        it "is valid." do
          first_add = build(:first, number: 1, valid_flag: false)
          expect(first_add).to be_valid
        end
      end
    end
  end
end
