require 'rails_helper'

RSpec.describe Seal, type: :model do
  let(:first_seal){ build(:first_seal) }

  %w{month sealed_date}.each do |column|
    describe "#{column}" do
      context 'is valid' do
        ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
          it "with #{value}." do
            first_seal[column] = value
            expect(first_seal).to be_valid
          end
        end
      end

      context 'is invalid' do
        ['1999/12/31', '2100/01/01'].each do |value|
          it "with #{value}." do
            first_seal[column] = value
            expect(first_seal).not_to be_valid
            expect(first_seal.errors[column]).to be_present
          end
        end
      end
    end
  end

  describe "Sealed flag" do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first_seal[:sealed_flag] = value
          expect(first_seal).to be_valid
        end
      end
    end

    context 'is invalid' do
      it "with empty." do
        first_seal[:sealed_flag] = ''
        expect(first_seal).not_to be_valid
        expect(first_seal.errors[:sealed_flag]).to be_present
      end
    end
  end

  describe "Staff nickname" do
    it "is valid with 10 words." do
      first_seal[:staff_nickname] = 'あ' * 10
      expect(first_seal).to be_valid
    end

    it "is invalid with 11 words." do
      first_seal[:staff_nickname] = 'あ' * 11
      expect(first_seal).not_to be_valid
      expect(first_seal.errors[:staff_nickname]).to be_present
    end
  end

  %w{sealed_date staff_nickname}.each do |column|
    describe "#{column}" do
      it "is invalid with empty when sealed_flag is true." do
        first_seal[column] = ''
        expect(first_seal).not_to be_valid
        expect(first_seal.errors[column]).to be_present
      end
    end
  end
end
