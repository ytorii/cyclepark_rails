require 'rails_helper'

RSpec.describe NumberSealsidListSearch, type: :model do

  let(:numid_list){ build(:number_sealsid_list_search) }

  before do
    create_list(:count_first_normal_1, 3)
    create(:count_first_normal_2).save!
  end 

  describe 'validation' do
    describe '#vhiecle_type' do
      it { is_expected.to validate_presence_of(:vhiecle_type) }
      it { is_expected.to allow_value('1', '2', '3').for(:vhiecle_type) }
      it { is_expected.not_to allow_value('0', '3.5', '4', 'a', 'あ').for(:vhiecle_type) }
    end

    describe '#month' do
      it { is_expected.to validate_presence_of(:month) }
      it { is_expected.to allow_value('2000/01/01', '2099/12/31').for(:month) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:month) }
      it { is_expected.not_to allow_value(0, true, 'a', 'あ').for(:month) }
    end

    describe '#skip_flag' do
      it { is_expected.to validate_inclusion_of(:sealed_flag).in_array([true, false])}
    end
  end

  describe '.initialize' do
    it 'sets instance values as expeted.' do
      numid_list = NumberSealsidListSearch.new
      expect(numid_list.vhiecle_type).to eq(1)
      expect(numid_list.month).to eq(Date.current.next_month)
      expect(numid_list.sealed_flag).to eq(false)
    end
  end

  describe '.result' do
    shared_examples 'returns the list' do
      it 'as expected numbers and ids.' do

        puts Leaf.all
        puts Contract.all
        
        # The date of the factorygirl's data is fixed,
        # so change the date with Timecop.
        Timecop.freeze('2016-06-03'.to_date)

        # Numbers change in rake spec because with multiple specs,
        # number sequentiality is taken over.
        numbers_list = Leaf.all.pluck(:number)

        expect(list.size).to eq(expected_ids.size)
        list.each_with_index do |numid, i|
          expect([ numid.number, numid.seal_id ]).
            to eq([ numbers_list[i], expected_ids[i] ])
        end

        # Restore the time as current.
        Timecop.return

      end
    end

    context 'with no params' do
      let(:expected_ids){ [ 3, 6, 9, 10 ] }
      let(:list){ NumberSealsidListSearch.new.result }
      it_behaves_like 'returns the list'
    end

    context 'with valid params' do
      let(:expected_ids){ [ 2, 5, 8 ] }
      let(:valid_params){
        { vhiecle_type: '1', month: '2016-06-25', sealed_flag: false }
      }
      let(:list){ NumberSealsidListSearch.new(valid_params).result }

      it_behaves_like 'returns the list'
    end
  end
end
