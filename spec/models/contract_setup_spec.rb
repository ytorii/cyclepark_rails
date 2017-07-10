require 'rails_helper'

RSpec.describe ContractSetup do
  let(:validated_contract){ build(:first_contract_reset_callbacks)}
  let(:first_contract_add){ build(:first_contract_add) }

  describe ".before_save", focus: true do
    subject{ validated_contract }
    context "with skip contract" do
      before{
        subject.skip_flag = true
        ContractSetup.new(subject).before_save
      }

      { term1: 1, money1: 0, term2: 0, money2: 0}.each do |key, value|
        it "sets #{key} to #{value}" do
          expect(subject[key]).to eq(value)
        end
      end
    end

    context "with non-skip contract" do
      context "with nil term2 and money2" do
        before{
          subject.term2 = subject.money2 = nil
          ContractSetup.new(subject).before_save
        }

        { term1: 1, money1: 1000, term2: 0, money2: 0 }.each do |key, value|
          it "sets #{key} to #{value}" do
            expect(subject[key]).to eq(value)
          end
        end
      end

      context "with not nil term2 and money2" do
        before{ ContractSetup.new(subject).before_save }

        { term1: 1, money1: 1000, term2: 6, money2: 18000 }.each do |key, value|
          it "leave #{key}" do
            expect(subject[key]).to eq(value)
          end
        end
      end
    end
  end

  describe ".before_create" do
    context "with no contracts" do
      before { first_contract.send(:set_contract_params) }

      it "sets new_flag to true." do
        expect(first_contract.new_flag).to eq(true)
      end
      it "sets start_month to leaf's start_date." do
        expect(first_contract.start_month).to eq(first.start_date)
      end
    end

    context "with contracts existed" do
      before {
        first_contract.save!
        first.reload
        first_contract_add.send(:set_contract_params)
      }

      it "sets new_flag to false." do
        expect(first_contract_add.new_flag).to eq(false)
      end
      it "sets start_month to next month of leaf's last_date." do
        expect(first_contract_add.start_month).to eq(first.last_date.next_month)
      end
    end

    shared_examples "seals except the first seal" do
      subject { first_contract.seals }
      let(:seals_size){ subject.size - 1 }

      it "the number of seal is equal to sum of term1 and term2." do
        expect(seals_size).to eq( first_contract.term1 + first_contract.term2 - 1 )
      end

      it "increments each seal's month from start_month one by one." do
        month = first_contract.start_month.beginning_of_month
        subject.each do |seal|
          expect(seal.month).to eq(month)
          month = month.next_month
        end
      end

      it "sets false to all seal's sealed_flag except the first seal." do
        1.upto(seals_size) do |i|
          expect(subject[i].sealed_flag).to eq(false)
        end
      end
    end

    context "with first sealed_flag true" do
      before {
        first_contract.send(:set_contract_params)
        first_contract.send(:set_seals_params)
      }

      it "sets seal's month to start_month." do
        expect(subject.first.month).to eq(first_contract.start_month.beginning_of_month)
      end

      it "sets seal's staff_nickname same as the contract." do
        expect(subject.first.staff_nickname).to eq(first_contract.staff_nickname)
      end

      it "sets seal's sealed_date to contract's contract_date." do
        expect(subject.first.sealed_date).to eq(first_contract.contract_date)
      end

      it_behaves_like 'seals except the first seal'
    end

    context "with first sealed_flag false" do
      before {
        subject.first.sealed_flag = param
        first_contract.send(:set_contract_params)
        first_contract.send(:set_seals_params)
      }

      it "sets seal's month to the first date of contract's start_month." do
        expect(subject.first.month).to eq(first_contract.start_month.beginning_of_month)
      end

      it "sets seal's staff_nickname to nil." do
        expect(subject.first.staff_nickname).to eq(nil)
      end

      it "sets seal's sealed_date to nil." do
        expect(subject.first.sealed_date).to eq(nil)
      end

      it_behaves_like 'seals except the first seal'
    end
  end

  describe ".before_update" do
    subject { first_contract.seals }

    before {
      first_contract.send(:set_seals_params)
      first_contract.send(:set_canceledseals_params)
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

  describe ".after_create" do
    subject { Leaf.find(first.id).last_date  }

    before {
      first_contract.send(:set_seals_params)
      first_contract.send(:update_leaf_lastdate)
    }

    it "updates leaf's last_date to contract's last month." do
      is_expected.to eq(first_contract.seals.last.month)
    end
  end

  describe ".after_destroy" do
    context "when leaf has contract" do
      before {
        first_contract.save!
        first_contract_add.save!
        first_contract_add.reload
        first_contract_add.destroy
      }

      it "updates leaf's last_date to contract's last month." do
        first.reload
        expect(first.last_date).to eq(first_contract.seals.last.month)
      end
    end

    context "when leaf has no contract" do
      before {
        first_contract.save!
        first_contract.reload
        first_contract.destroy
      }
      it "updates leaf's last_date to nil." do
        first.reload
        expect(first.last_date).to eq(nil)
      end
    end
  end

  #TODO: Move this test to validation module!!
  describe ".last_contract?" do
    before { 
      first_contract.save!
      first_contract_add.save!
    }

    context "with last contract" do
      it "returns nil(means no problem)" do
        expect(first_contract_add.send(:last_contract?)).to eq(nil)
      end
    end

    context "with not the last contract" do
      it "returns false" do
        expect(first_contract.send(:last_contract?)).to eq(false)
      end
    end
  end
end
