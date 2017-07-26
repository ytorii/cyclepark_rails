require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:leaf){ create(:first) }
  let(:contract){ build(:first_contract, leaf_id: leaf.id) }

  describe 'association' do
    it { is_expected.to belong_to(:leaf) }
    it { is_expected.to have_many(:seals) }
  end

  describe 'validation' do
    context "with skip_flag true" do
      subject{ Contract.new(skip_flag: true) }
      it { is_expected.not_to validate_presence_of(:term1) }
      it { is_expected.not_to validate_presence_of(:money1) }
    end

    context "with skip_flag false" do
      subject{ Contract.new(skip_flag: false) }
      it { is_expected.to validate_presence_of(:term1) }
      it { is_expected.to validate_presence_of(:money1) }
    end

    describe '#contract_date' do
      it { is_expected.to validate_presence_of(:contract_date) }
      it { is_expected.to allow_value('2000/1/1', '2099/12/31').for(:contract_date) }
      it { is_expected.not_to allow_value('1999/12/31', '2100/01/01').for(:contract_date) }
    end

    describe '#term1' do
      it { is_expected.to validate_numericality_of(:term1).
           is_greater_than_or_equal_to(1).
           is_less_than_or_equal_to(12).
           allow_nil }
    end

    describe '#term2' do
      it { is_expected.to validate_numericality_of(:term2).
           is_greater_than_or_equal_to(0).
           is_less_than_or_equal_to(6).
           allow_nil }
    end

    describe '#money1' do
      it { is_expected.to validate_numericality_of(:money1).
           is_greater_than_or_equal_to(0).
           is_less_than_or_equal_to(36_000).
           allow_nil }
    end

    describe '#money2' do
      it { is_expected.to validate_numericality_of(:money2).
           is_greater_than_or_equal_to(0).
           is_less_than_or_equal_to(18_000).
           allow_nil }
    end


    describe '#skip_flag' do
      it { is_expected.to validate_inclusion_of(:skip_flag).in_array([true, false])}
    end

    describe '.update' do
      before { contract.save! }
      context 'with nickname in Staffs DB' do
        before{ contract.update(staff_nickname: 'admin') }
        it "is valid." do
          expect(contract).to be_valid
        end
      end

      context 'with nickname NOT in Staffs DB' do
        before{ contract.update(staff_nickname: 'nostaff') }
        it "is invalid." do
          expect(contract).not_to be_valid
        end
      end

      context "with unchanged terms" do
        before{ contract.update(term1: 1, term2: 6) }
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

    describe '.destroy' do
      subject{ contract.last_contract? }
      before{
        leaf.contracts.push(contract)
      }
      context "with leaf's last contract" do
        it 'successes to destroy contract.' do
          is_expected.to be_truthy
        end
      end
      context "with not leaf's last contract" do
        let(:contract2){ build(:first_contract_add, leaf_id: leaf.id) }
        before{ 
          leaf.contracts.push(contract2)
        }
        it 'fails to destroy contract.' do
          is_expected.to be_falsey
        end
      end
    end
  end

  describe 'callback' do
    let(:contract_params_setup) { expect(ContractParamsSetup) } 
    let(:leaf_updator) { expect(LeafLastDateUpdator) } 

    describe '.save' do
      #after{ contract.save! }

      it 'calls ContractParamsSetup.before_save once.' do
        contract_params_setup.to receive(:before_save).once.with(contract)
        contract.run_callbacks(:save){ false }
      end

      it 'calls ContractParamsSetup.before_create once.' do
        contract_params_setup.to receive(:before_create).once.with(contract)
        contract.run_callbacks(:create){ false }
      end

      it 'calls LeafLastDateUpdator.after_create once.' do
        leaf_updator.to receive(:after_create).once.with(contract)
        contract.save!
      end
    end

    describe '.update' do
      before{
        contract.save
        contract.reload
      }
      after{ contract.update(money1: 2000) }

      it 'calls ContractParamsSetup.before_save once.' do
        contract_params_setup.to receive(:before_save).once.with(contract)
      end

      it 'calls ContractParamsSetup.before_update once.' do
        contract_params_setup.to receive(:before_update).once.once.with(contract)
      end
    end

    describe '.destroy' do
      before{
        contract.save
        contract.reload
        leaf.contracts.push(contract)
      }
      after{ contract.destroy }

      it 'calls .last_contract? once.' do
        expect(contract).to receive(:last_contract?).once
      end

      it 'calls LeafLastDateUpdator.after_destroy once.' do
        leaf_updator.to receive(:after_destroy).once
      end
    end
  end
end
