require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:leaf){ create(:first) }
  let(:contract){ build(:first_contract, leaf_id: leaf.id) }
  let(:contract_add){ build(:first_contract_add, leaf_id: leaf.id) }

  describe 'association' do
    it { is_expected.to belong_to(:leaf) }
    it { is_expected.to has_many(:seals) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:contract_date) }

  end

  describe "contract_date" do
    context 'is valid' do
      ['2000/1/1', '2000-1-1', '2099/12/31'].each do |value|
        it "with #{value}." do
          contract[:contract_date] = value
          expect(contract).to be_valid
        end
      end
    end

    context 'is invalid' do
      ['1999/12/31', '2100/01/01'].each do |value|
        it "with #{value}." do
          contract[:contract_date] = value
          expect(contract).not_to be_valid
          expect(contract.errors[:contract_date]).to be_present
        end
      end
    end
  end

  { term1: 12, money1: 36000, term2: 9, money2: 18000}.each do |key, value|
    describe "#{key}" do
      it "is valid with #{value}." do
        contract[key] = value
        expect(contract).to be_valid
      end

      it "is invalid with #{value + 1}." do
        contract[key] = value + 1
        expect(contract).not_to be_valid
        expect(contract.errors[key]).to be_present
      end
    end
  end

  %w{term1 money1}.each do |column|
    describe "#{column}" do
      context "with skip_flag true" do
        it "is valid with nil" do
          contract[:skip_flag] =  true
          contract[column] = nil
          expect(contract).to be_valid
        end
      end
      context "with skip_flag false" do
        it "is invalid with nil" do
          contract[column] = nil
          expect(contract).not_to be_valid
        end
      end
    end
  end

  %w{term2 money2}.each do |column|
    describe "#{column}" do
      it "is valid with nil" do
        contract[column] = nil
        expect(contract).to be_valid
      end
    end
  end


  describe "skip_flag" do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          contract[:skip_flag] = value
          expect(contract).to be_valid
        end
      end
    end
  end

  describe "staff_nickname" do
    it "is valid with nickanme in Staffs DB." do
      expect(contract).to be_valid
    end

    it "is invalid with nickanme NOT in Staffs DB." do
      contract[:staff_nickname] = 'nostaff'
      expect(contract).not_to be_valid
      expect(contract.errors[:staff_nickname]).to be_present
    end
  end

  describe "term1 and term2" do
    before { contract.save! }

    context "with unchanged terms" do
      before{ contract.update(term1: 1) }
      it "is valid." do
        expect(contract).to be_valid
      end
    end

    context "with changed term1." do
      before{ contract.update(term1: 3)}
      it "is invalid" do
        expect(contract).not_to be_valid
      end
    end

    context "with changed term2." do
      before{ contract.update(term2: 3)}
      it "is invalid" do
        expect(contract).not_to be_valid
      end
    end
  end
end
