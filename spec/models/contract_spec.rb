require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:first){ create(:first) }
  let(:first_contract){ build(:first_contract, leaf_id: first.id) }
  let(:first_contract_add){ build(:first_contract_add, leaf_id: first.id) }

  before{
    create(:admin)
    first 
  }

  %w{contract_date}.each do |column|
    describe "#{column}" do
      before{
        first_contract.save!
      }

      context 'is valid' do
        ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
          it "with #{value}." do
            first_contract[column] = value
            expect(first_contract).to be_valid
          end
        end
      end

      context 'is invalid' do
        ['1999/12/31', '2100/01/01'].each do |value|
          it "with #{value}." do
            first_contract[column] = value
            expect(first_contract).not_to be_valid
            expect(first_contract.errors[column]).to be_present
          end
        end
      end
    end
  end

  { term1: 9, money1: 18000, term2: 9, money2: 18000}.each do |key, value|
    describe "#{key}" do
      it "is valid with #{value} words." do
        first_contract[key] = value
        expect(first_contract).to be_valid
      end

      it "is invalid with #{value + 1} words." do
        first_contract[key] = value + 1
        expect(first_contract).not_to be_valid
        expect(first_contract.errors[key]).to be_present
      end
    end
  end

  describe "money2" do
    it "is invalid with empty when term2 exists." do
      first_contract[:money2] = ''
      expect(first_contract).not_to be_valid
      expect(first_contract.errors[:money2]).to be_present
    end
  end

  describe "term2, money2" do
    ['', nil].each do |value|
      it "are valid with both empty or nil" do
        first_contract[:term2] = value
        first_contract[:money2] = value
        expect(first_contract).to be_valid
      end
    end
  end

  %w{skip_flag new_flag}.each do |column|
    describe "#{column}" do
      context 'is valid' do
        [true, false].each do |value|
          it "with #{value}." do
            first_contract[column] = value
            expect(first_contract).to be_valid
          end
        end
      end

      context 'is invalid' do
        it "with empty." do
          first_contract[column] = ''
          expect(first_contract).not_to be_valid
          expect(first_contract.errors[column]).to be_present
        end
      end
    end
  end

  describe "staff_nickname" do
    it "is valid with nickanme in Staffs DB." do
      expect(first_contract).to be_valid
    end

    it "is valid with nickanme in Staffs DB." do
      first_contract[:staff_nickname] = 'nostaff'
      expect(first_contract).not_to be_valid
      expect(first_contract.errors[:staff_nickname]).to be_present
    end
  end

  describe ".buildSeals" do
    context "when sealed_flag is true" do
      before{
        first_contract.save!
      }

      it "saves Seal records as many as sum of term1 and term2." do
        expect(Contract.find(first_contract.id).seals.size).to eq(first_contract.term1 + first_contract.term2)
      end

      it "increments each seal's month from start_month one by one." do
        month = first_contract.start_month
        first_contract.seals.size.times do |i|
          expect(Contract.find(first_contract.id).seals[i].month).to eq(month)
          month = month.next_month
        end
      end

      it "updates leaf's last month to Seals' last month." do
        first.reload
        expect(Leaf.find(first_contract.leaf_id).last_date).to eq(first_contract.seals.last.month)
      end

      it "sets true to the first seal's sealed_flag and sets false to the others." do
        expect(Contract.find(first_contract.id).seals.first.sealed_flag).to eq(true)
        (first_contract.seals.size - 1).times do |i|
          expect(Contract.find(first_contract.id).seals[i + 1].sealed_flag).to eq(false)
        end
      end

      it "sets contract's staff_nickname to the first seal's staff_nickname" do
        expect(Contract.find(first_contract.id).seals.first.staff_nickname).to eq(first_contract.staff_nickname)
      end

      it "sets contract's contract_date to the first seal's sealed_date" do
        expect(Contract.find(first_contract.id).seals.first.sealed_date).to eq(first_contract.contract_date)
      end
    end

    context "when sealed_flag is false" do
      before{
        first_contract.seals.first.sealed_flag = false
        first_contract.save!
      }

      it "saves Seal records as many as sum of term1 and term2." do
        expect(Contract.find(first_contract.id).seals.size).to eq(first_contract.term1 + first_contract.term2)
      end

      it "increments each seal's month from start_month one by one." do
        month = first_contract.start_month
        first_contract.seals.size.times do |i|
          expect(Contract.find(first_contract.id).seals[i].month).to eq(month)
          month = month.next_month
        end
      end

      it "updates leaf's last month to Seals' last month." do
        first.reload
        expect(Leaf.find(first_contract.leaf_id).last_date).to eq(first_contract.seals.last.month)
      end

      it "sets false to all seal's sealed_flag." do
        first_contract.seals.size.times do |i|
          expect(Contract.find(first_contract.id).seals[i].sealed_flag).to eq(false)
        end
      end
    end
  end

  describe ".buildContract" do
    context "when leaf has no contracts" do
      before{
        first_contract.save!
      }

      it "sets contract's new_flag to true" do
        expect(first_contract.new_flag).to eq(true)
      end

      it "sets contract's start_month to leaf's start_date" do
        expect(first_contract.start_month).to eq(first.start_date)
      end
    end

    context "when leaf has existed contracts" do
      before{
        first_contract.save!
        first.reload
        #first_contract_add.leaf_id = first.id
        first_contract_add.save!
      }

      it "sets contract's new_flag to false" do
        expect(first_contract_add.new_flag).to eq(false)
      end

      it "sets contract's start_month to next of leaf's last_date" do
        expect(first_contract_add.start_month).to eq(first.last_date.next_month)
      end
    end
  end

  describe ".setContractParams" do
    context "with no contracts" do
      before { first_contract.send(:setContractParams) }

      it "sets new_flag to false." do
        expect(first_contract.new_flag).to eq(true)
      end
      it "sets start_month to next month of leaf's start_date." do
        expect(first_contract.start_month).to eq(first.start_date)
      end
    end

    context "with existed contracts" do
      before {
        first_contract.save!
        first.reload
        first_contract_add.send(:setContractParams)
      }

      it "sets new_flag to true." do
        expect(first_contract_add.new_flag).to eq(false)
      end
      it "sets start_month to next month of leaf's last_date." do
        expect(first_contract_add.start_month).to eq(first.last_date.next_month)
      end
    end
  end

  describe ".setFirstSealParams" do
    subject { first_contract.seals.first }

    context "with first sealed_flag true" do
      before { first_contract.send(:setFirstSealParams) }

      it "sets seal's month to start_month." do
        expect(subject.month).to eq(first_contract.start_month)
      end
      it "sets seal's staff_nickname to contract's." do
        expect(subject.staff_nickname).to eq(first_contract.staff_nickname)
      end
      it "sets seal's sealed_date to contract's contract_date." do
        expect(subject.sealed_date).to eq(first_contract.contract_date)
      end
    end

    context "with first sealed_flag false" do
      before {
        subject.sealed_flag = false
        first_contract.send(:setFirstSealParams)
      }

      it "sets seal's month to start_month." do
        expect(subject.month).to eq(first_contract.start_month)
      end
      it "sets seal's staff_nickname to nil." do
        expect(subject.staff_nickname).to eq(nil)
      end
      it "sets seal's sealed_date to nil." do
        expect(subject.sealed_date).to eq(nil)
      end
    end
  end

  describe ".setRestSealsParams" do
    subject { first_contract.seals }

    before {
      subject.first.sealed_flag = false
      first_contract.send(:setFirstSealParams)
      first_contract.send(:setRestSealsParams)
    }

    it "the number of seals is equal to sum of term1 and term2." do
      expect(subject.size).to eq(first_contract.term1 + first_contract.term2)
    end

    it "increments each seal's month from start_month one by one." do
      month = first_contract.start_month
      subject.each do |seal|
        expect(seal.month).to eq(month)
        month = month.next_month
      end
    end

    it "sets false to all seal's sealed_flag." do
      subject.each do |seal|
        expect(seal.sealed_flag).to eq(false)
      end
    end
  end

  describe ".setCanceledSealsParams", focus: true do
    subject { first_contract.seals }

    before {
      first_contract.send(:setFirstSealParams)
      first_contract.send(:setRestSealsParams)
      first_contract.send(:setCanceledSealsParams)
    }

    context "with true sealed_flag" do
      it "keeps sealed_date and staff_nickname." do
        tmp_sealed_date = subject.first.sealed_date
        tmp_staff_nickname = subject.first.staff_nickname
        expect(subject.first.sealed_date).to eq(tmp_sealed_date)
        expect(subject.first.staff_nickname).to eq(tmp_staff_nickname)
      end
    end

    context "with false sealed_flag" do
      it "sets sealed_date and staff_nickname to nil." do
        for i in 1..(subject.size-1)
          expect(subject[i].sealed_date).to eq(nil)
          expect(subject[i].staff_nickname).to eq(nil)
        end
      end
    end
  end
end
