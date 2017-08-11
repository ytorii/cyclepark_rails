require 'rails_helper'

RSpec.describe ContractParamsSetup do
  let(:leaf){ build(:first, id: 1) }
  let(:validated_contract){ build(:first_contract_no_callbacks, leaf: leaf) }
  let(:existing_contract){ build(:first_contract_add) }

  describe ".before_save" do
    subject{ ContractParamsSetup.before_save(validated_contract) }
    context "with skip contract" do
      before{
        validated_contract.skip_flag = true
        subject
      }

      { term1: 1, money1: 0, term2: 0, money2: 0}.each do |key, value|
        it "sets #{key} to #{value}" do
          expect(validated_contract[key]).to eq(value)
        end
      end
    end

    context "with non-skip contract" do
      context "with nil term2 and money2" do
        before{
          validated_contract.term2 = validated_contract.money2 = nil
          subject
        }

        { term1: 1, money1: 1000, term2: 0, money2: 0 }.each do |key, value|
          it "sets contract #{key} to #{value}" do
            expect(validated_contract[key]).to eq(value)
          end
        end
      end

      context "with not nil term2 and money2" do
        before{ subject }

        { term1: 1, money1: 1000, term2: 6, money2: 18000 }.each do |key, value|
          it "leave #{key}" do
            expect(validated_contract[key]).to eq(value)
          end
        end
      end
    end
  end

  describe ".before_create" do
    subject{ ContractParamsSetup.before_create(validated_contract) }

    context "with no contracts for its leaf" do
      before{ subject }

      it "sets contract new_flag to true." do
        expect(validated_contract.new_flag).to eq(true)
      end
      it "sets start_month to the 1st of leaf's start_date's month." do
        expect(validated_contract.start_month).
          to eq(leaf.start_date.beginning_of_month)
      end
    end

    context "with contracts existed for its leaf" do
      before{
        leaf.contracts.push existing_contract
        subject
      }
      it "sets contract new_flag to false." do
        expect(validated_contract.new_flag).to eq(false)
      end
      it "sets start_month to next month of leaf's last_date." do
        expect(validated_contract.start_month).
          to eq(leaf.last_date.next_month.beginning_of_month)
      end
    end

    it 'calls SealParamsSetup once with @contract' do
      expect(SealParamsSetup).
        to receive(:before_create).once.with(validated_contract)
      subject
    end
  end

  describe ".before_update" do
    it 'calls SealParamsSetup once with @contract' do
      expect(SealParamsSetup).
        to receive(:before_update).once.with(validated_contract)
      ContractParamsSetup.before_update(validated_contract)
    end
  end
end
