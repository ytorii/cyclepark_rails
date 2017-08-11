require 'rails_helper'

RSpec.describe MultiSealsUpdate, type: :model do
  let(:multi_seals){ build(:multi_seals) }

  before{ multi_seals }

  describe 'validation' do
    describe '#sealed_date' do
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').for(:sealed_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:sealed_date) }
      it { is_expected.not_to allow_value(nil, 0, true, 'a', 'あ').for(:sealed_date) }
    end

    describe "#staff_nickname" do
      subject{ MultiSealsUpdate.new }
      it "calls staff_exits? method once." do
        is_expected.to receive(:staff_exists?).once
        subject.valid?
      end
    end

    describe '#sealsid_list' do
      it { is_expected.to allow_value(['1', '3', '9']).for(:sealsid_list) }
      it { is_expected.not_to allow_value([""], [], nil).for(:sealsid_list) }
      it { is_expected.
           not_to allow_value('', 'あ', ["1", "2", 'a']).for(:sealsid_list) }
    end
  end

  describe ".update_selected_seals" do
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
        expect(multi_seals.update_selected_seals).to eq(false)
      end
    end

    context "with empty staff_nickname" do
      it 'returns false.' do
        multi_seals.staff_nickname = ''
        expect(multi_seals.update_selected_seals).to eq(false)
      end
    end

    context "with empty sealsid_list" do
      it 'returns false.' do
        multi_seals.sealsid_list = ''
        expect(multi_seals.update_selected_seals).to eq(false)
      end
    end

    context "with 0 size sealsid_list" do
      it 'returns false.' do
        multi_seals.sealsid_list = []
        expect(multi_seals.update_selected_seals).to eq(false)
      end
    end

    context "with existed seal ids in the list" do
      let(:selected_seals){ Seal.find(multi_seals.sealsid_list) }

      before{
        multi_seals.update_selected_seals
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
        expect(multi_seals.update_selected_seals).to eq(true)
      end
    end

    context "with NOT existed seal ids in the list" do
      # Seal ids except non exist one.
      # Check should be executed with these, to avoid exception!
      let(:selected_seals){ Seal.find([ 1, 3, 5, 6 ]) }

      before{
        multi_seals.sealsid_list = [ 1, 3, 12, 5, 6 ]
        multi_seals.update_selected_seals
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
        expect(multi_seals.update_selected_seals).to eq(false)
      end
    end
  end
end
