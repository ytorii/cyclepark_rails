require 'rails_helper'

RSpec.describe NumberSealsidListSearch, type: :model do

  let(:numid_list){ build(:number_sealsid_list_search) }

  before :all do
    create_list(:count_first_normal_1, 3)
    create(:count_first_normal_2)
  end 

  describe 'vhiecle_type' do
    [*1..3].each do |value|
      context "with #{value}." do
        it 'is valid' do
          numid_list.vhiecle_type = value
          expect(numid_list).to be_valid
        end
      end
    end

    [0, 3.5, 4, 'a', 'あ'].each do |value|
      context "with #{value}." do
        it 'is invalid' do
          numid_list.vhiecle_type = value
          expect(numid_list).not_to be_valid
          expect(numid_list.errors[:vhiecle_type]).to be_present
        end
      end
    end
  end

  describe "month" do
    context 'is valid' do
      ['2000/01/01', '2000-01-01', '2099/12/31'].each do |value|
        it "with #{value}." do
          numid_list.month = value
          expect(numid_list).to be_valid
        end
      end
    end

    context 'is invalid' do
      [ '1999/12/31', '2100/01/01', 'あ', 'a', 1, nil ].each do |value|
        it "with #{value}." do
          numid_list.month = value
          expect(numid_list).not_to be_valid
          expect(numid_list.errors[:month]).to be_present
        end
      end
    end
  end

  describe 'sealed_flag' do
    [true, false].each do |value|
      context "with #{value}." do
        it 'is valid' do
          numid_list.sealed_flag = value
          expect(numid_list).to be_valid
        end
      end
    end

    ['a', 'あ', 0, 1, nil].each do |value|
      context "with #{value}." do
        it 'is invalid' do
          numid_list.sealed_flag = value
          expect(numid_list).not_to be_valid
          expect(numid_list.errors[:sealed_flag]).to be_present
        end
      end
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
      let(:list){
        NumberSealsidListSearch.new('1', '2016-06-25', 'false').result 
      }
      it_behaves_like 'returns the list'
    end
  end
end
