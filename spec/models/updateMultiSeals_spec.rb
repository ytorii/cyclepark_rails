require 'rails_helper'

RSpec.describe UpdateMultiSeals, type: :model do
  let(:multi_seals){ build(:multi_seals) }

  describe "Sealed Date" do
    ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
      context "with #{value}" do
        it 'is valid.' do
          multi_seals[:sealed_date] = value
          expect(multi_seals).to be_valid
        end
      end
    end

    ['1999/12/31', '2100/01/01', ''].each do |value|
      context "with #{value}" do
        it 'is invalid.' do
          multi_seals[:sealed_date] = value
          expect(multi_seals).not_to be_valid
          expect(multi_seals.errors[:sealed_date]).to be_present
        end
      end
    end
  end

  describe "staff_nickname" do
    context "with nickanme in Staffs DB" do
      it "is valid." do
        multi_seals[:staff_nickname] = 'admin'
        expect(multi_seals).to be_valid
      end
    end

    context "with nickanme NOT in Staffs DB" do
      it "is invalid." do
        multi_seals[:staff_nickname] = 'nostaff'
        expect(multi_seals).not_to be_valid
        expect(multi_seals.errors[:staff_nickname]).to be_present
      end
    end
  end

  describe "number_sealsid_list" do
    ['', [""]].each do |value|
      context "with #{value}" do
        it 'is invalid.' do
          multi_seals[:number_sealsid_list] = value
          expect(multi_seals).not_to be_valid
          expect(multi_seals.errors[:number_sealsid_list]).to be_present
        end
      end
    end
  end
end
