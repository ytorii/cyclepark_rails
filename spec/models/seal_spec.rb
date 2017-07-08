require 'rails_helper'

RSpec.describe Seal, type: :model do
  let(:first_seal){ build(:first_seal) }

  describe "Month" do
    before{ first_seal }
    context 'is valid' do
      ['2000/1/1', '2000-1-1', '2099/12/31', nil].each do |value|
        it "with #{value}." do
          first_seal.month = value
          expect(first_seal).to be_valid
        end
      end
    end

    context 'is invalid' do
      ['1999/12/31', '2100/01/01'].each do |value|
        it "with #{value}." do
          first_seal.month = value
          expect(first_seal).not_to be_valid
          expect(first_seal.errors[:month]).to be_present
        end
      end

      it "with nil on update." do
        first_seal.save!
        first_seal.update(month: nil)
        expect(first_seal).not_to be_valid
        expect(first_seal.errors[:month]).to be_present
      end
    end
  end

  describe "Sealed date" do
    context 'is valid' do
      it "with nil on create." do
        first_seal.sealed_date = nil
        expect(first_seal).to be_valid
      end

      ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
        it "with #{value} on update." do
          first_seal.save!
          first_seal.update(sealed_date: value)
          expect(first_seal).to be_valid
        end
      end
    end

    context 'is invalid' do
      ['1999/12/31', '2100/01/01', nil].each do |value|
        it "with #{value}." do
          first_seal.save!
          first_seal.update(sealed_date: value)
          expect(first_seal).not_to be_valid
          expect(first_seal.errors[:sealed_date]).to be_present
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
    context "on create" do
      it "is valid with nil." do
        first_seal[:staff_nickname] = nil
        expect(first_seal).to be_valid
      end
    end

    context "on update" do
      context "with sealed_flag true" do
        before { first_seal.save! }

        it "is valid with 10 words." do
          first_seal.update(staff_nickname: 'あ' * 10)
          expect(first_seal).to be_valid
        end

        it "is invalid with 11 words." do
          first_seal.update(staff_nickname: 'あ' * 11)
          expect(first_seal).not_to be_valid
          expect(first_seal.errors[:staff_nickname]).to be_present
        end

        it "is invalid with nil." do
          first_seal.update(staff_nickname: nil)
          expect(first_seal).not_to be_valid
          expect(first_seal.errors[:staff_nickname]).to be_present
        end
      end
    end
  end
end
