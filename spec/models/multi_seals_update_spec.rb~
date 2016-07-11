require 'rails_helper'

RSpec.describe MultiSealsUpdate, type: :model do
  let(:multi_seals){ build(:multi_seals) }

  before{
    create(:admin)
    multi_seals
  }

  describe "Sealed Date" do
    ['2000/01/01', '2000-01-01', '2099/12/31'].each do |value|
      context "with #{value}" do
        it 'is valid.' do
          multi_seals.sealed_date = value
          expect(multi_seals).to be_valid
        end
      end
    end

    ['1999/12/31', '2100/01/01', '', 'あ'].each do |value|
      context "with #{value}" do
        it 'is invalid.' do
          multi_seals.sealed_date = value
          expect(multi_seals).not_to be_valid
          expect(multi_seals.errors[:sealed_date]).to be_present
        end
      end
    end
  end

  describe "staff_nickname" do
    context "with nickanme in Staffs DB" do
      it "is valid." do
        multi_seals.staff_nickname = 'admin'
        expect(multi_seals).to be_valid
      end
    end

    context "with nickanme NOT in Staffs DB" do
      it "is invalid." do
        multi_seals.staff_nickname = 'nostaff'
        expect(multi_seals).not_to be_valid
        expect(multi_seals.errors[:staff_nickname]).to be_present
      end
    end
  end

  describe "sealsid_list" do
    [ '', 'あ', [""], ["1", "2", 'a'] ].each do |value|
      context "with #{value}" do
        it 'is invalid.' do
          multi_seals.sealsid_list = value
          expect(multi_seals).not_to be_valid
          expect(multi_seals.errors[:sealsid_list]).to be_present
        end
      end
    end
  end

  describe ".updateSelectedSeals" do
    before{
      month = Date.parse("2016-04-01")

      10.times do
        create(:seal_multi, month: month)
        month = month.next_month
      end
    }

    context "with empty sealed_date" do
      it 'returns false.' do
        multi_seals.sealed_date = ''
        expect(multi_seals.updateSelectedSeals).to eq(false)
      end
    end

    context "with empty staff_nickname" do
      it 'returns false.' do
        multi_seals.staff_nickname = ''
        expect(multi_seals.updateSelectedSeals).to eq(false)
      end
    end

    context "with empty sealsid_list" do
      it 'returns false.' do
        multi_seals.sealsid_list = ''
        expect(multi_seals.updateSelectedSeals).to eq(false)
      end
    end

    context "with 0 size sealsid_list" do
      it 'returns false.' do
        multi_seals.sealsid_list = []
        expect(multi_seals.updateSelectedSeals).to eq(false)
      end
    end

    context "with existed seal ids in the list" do
      let(:selected_seals){ Seal.find(multi_seals.sealsid_list) }

      before{
        multi_seals.updateSelectedSeals
      }

      it 'sets sealed_flag of selected seals to true.' do
        selected_seals.each do |seal|
          expect(seal.sealed_flag).to eq(true)
        end
      end

      it 'sets sealed_date of selected seals to 2016-03-31.' do
        selected_seals.each do |seal|
          expect(seal.sealed_date).
            to eq(Date.parse(multi_seals.sealed_date))
        end
      end

      it 'sets staff_nickname of selected seals to admin.' do
        selected_seals.each do |seal|
          expect(seal.staff_nickname).to eq(multi_seals.staff_nickname)
        end
      end

      it 'keeps sealed_flag of NOT selected seals as false.' do
        unselected_seals = Seal.where.not(
          id: multi_seals.sealsid_list
        )
        unselected_seals.each do |seal|
          expect(seal.sealed_flag).to eq(false)
        end
      end

      it 'returns true.' do
        expect(multi_seals.updateSelectedSeals).to eq(true)
      end
    end

    context "with NOT existed seal ids in the list" do
      # Seal ids except non exist one.
      # Check should be executed with these, to avoid exception!
      let(:selected_seals){ Seal.find([ 1, 3, 5, 6 ]) }

      before{
        multi_seals.sealsid_list = [ 1, 3, 12, 5, 6 ]
        multi_seals.updateSelectedSeals
      }

      it 'sets sealed_flag of selected seals to false.' do
        selected_seals.each do |seal|
          expect(seal.sealed_flag).to eq(false)
        end
      end

      it 'sets sealed_date of selected seals to nil.' do
        selected_seals.each do |seal|
          expect(seal.sealed_date).to eq(nil)
        end
      end

      it 'sets staff_nickname of selected seals to nil.' do
        selected_seals.each do |seal|
          expect(seal.staff_nickname).to eq(nil)
        end
      end

      it 'returns false.' do
        expect(multi_seals.updateSelectedSeals).to eq(false)
      end
    end
  end
end
