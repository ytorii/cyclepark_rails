require 'rails_helper'

RSpec.describe ContractSetup do
  let(:leaf){ build(:first, id: 1) }
  let(:validated_contract){ build(:first_contract_no_callbacks, leaf_id: leaf.id) }
  let(:validated_contract_seals){ build(:first_contract_no_callbacks_seals, leaf_id: leaf.id) }
  let(:seals){ validated_contract.seals }
  let(:multiple_seals){ validated_contract_seals.seals }
  let(:existing_contract){ build(:first_contract_add, leaf_id: leaf.id) }

  describe ".before_save" do
    subject{ ContractSetup.new(validated_contract, leaf).before_save }
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
    subject{ ContractSetup.new(validated_contract, leaf).before_create }

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
        existing_contract.save!
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

    context "with first sealed_flag true" do
      before { subject }

      it "sets seal's staff_nickname same as the contract." do
        expect(seals.first.staff_nickname).to eq(validated_contract.staff_nickname)
      end

      it "sets seal's sealed_date to contract's contract_date." do
        expect(seals.first.sealed_date).to eq(validated_contract.contract_date)
      end

      it "increments each seal's month from contract start_month one by one." do
        month = validated_contract.start_month
        seals.each do |seal|
          expect(seal.month).to eq(month)
          month = month.next_month
        end
      end

      it "sets rest seal as unsealed ones." do
        1.upto(seals.size - 1) do |i|
          expect(seals[i].sealed_flag).to eq(false)
          expect(seals[i].staff_nickname).to eq(nil)
          expect(seals[i].sealed_date).to eq(nil)
        end
      end
    end

    context "with sealed_flag false" do
      before { 
        validated_contract.seals.first.sealed_flag = false
        subject
      }

      it "sets seals params as not sealed ones." do
        month = validated_contract.start_month
        seals.each do |seal|
          expect(seal.month).to eq(month)
          expect(seal.sealed_flag).to eq(false)
          expect(seal.staff_nickname).to eq(nil)
          expect(seal.sealed_date).to eq(nil)
          month = month.next_month
        end
      end
    end
  end

  describe ".before_update" do
    subject{ ContractSetup.new(validated_contract_seals, leaf).before_update }

    before {
      # Set all seal true and set nickname and date,
      # then random 3 seals are set sealed_flag to false
      multiple_seals.each do |seal|
        seal.sealed_flag = true
        seal.staff_nickname = validated_contract_seals.staff_nickname
        seal.sealed_date = validated_contract_seals.contract_date
      end
      multiple_seals.sample(3).each { |seal| seal.sealed_flag = false }
      subject
    }

    context "with true sealed_flag" do
      it "keeps sealed_date and staff_nickname." do
        multiple_seals.select{|s| s.sealed_flag}.each do |seal| 

          expect(seal.sealed_date).to eq(validated_contract_seals.contract_date)
          expect(seal.staff_nickname).to eq(validated_contract_seals.staff_nickname)
        end
      end
    end

    context "with false sealed_flag" do
      it "sets sealed_date and staff_nickname to nil." do
        multiple_seals.select{|s| !s.sealed_flag}.each do |seal| 
          expect(seal.sealed_date).to eq(nil)
          expect(seal.staff_nickname).to eq(nil)
        end
      end
    end
  end

  describe ".after_create" do
    subject { leaf.last_date }

    before { ContractSetup.new(validated_contract_seals, leaf).after_create }

    it "updates leaf's last_date to contract's last day." do
      is_expected.
        to eq(validated_contract_seals.seals.last.month.end_of_month)
    end
  end

  describe ".after_destroy" do
    subject { leaf.last_date }
    context "when leaf has contract" do
      before {
        # leaf's last_date and last contract's month is different
        leaf.contracts.push(validated_contract_seals)
        leaf.last_date = multiple_seals.last.month.end_of_month + 1.months
        ContractSetup.new(validated_contract_seals, leaf).after_destroy
      }

      it "updates leaf's last_date to contract's last month." do
        is_expected.to eq(multiple_seals.last.month.end_of_month)
      end
    end

    context "when leaf has no contract" do
      before {
        leaf.last_date = multiple_seals.last.month.end_of_month + 1.months
        ContractSetup.new(validated_contract_seals, leaf).after_destroy
      }
      it "updates leaf's last_date to nil." do
        is_expected.to eq(nil)
      end
    end
  end
end
