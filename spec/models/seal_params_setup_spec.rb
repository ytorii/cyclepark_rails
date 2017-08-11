require 'rails_helper'

RSpec.describe SealParamsSetup do
  let(:leaf){ build(:first, id: 1) }
  let(:validated_contract){
    build(:first_contract_no_callbacks, leaf: leaf) }
  let(:validated_contract_seals){
    build(:first_contract_no_callbacks_seals, leaf: leaf) }

  describe ".before_create" do
    subject { validated_contract.seals }
    context "with first sealed_flag true" do
      before { SealParamsSetup.before_create(validated_contract) }
      it "sets seal's staff_nickname same as the contract." do
        expect(subject.first.staff_nickname).
          to eq(validated_contract.staff_nickname)
      end

      it "sets seal's sealed_date to contract's contract_date." do
        expect(subject.first.sealed_date).
          to eq(validated_contract.contract_date)
      end

      it "increments each seal's month from contract start_month one by one." do
        month = subject.first.month
        subject.each do |seal|
          expect(seal.month).to eq(month)
          month = month.next_month
        end
      end

      it "sets rest seal as unsealed ones." do
        # First seal is excluded.
        subject[1..-1].each do |seal|
          expect(seal.sealed_flag).to eq(false)
          expect(seal.staff_nickname).to eq(nil)
          expect(seal.sealed_date).to eq(nil)
        end
      end
    end

    context "with sealed_flag false" do
      before {
        subject.first.sealed_flag = false
        SealParamsSetup.before_create(validated_contract)
      }

      it "sets seals params as not sealed ones." do
        month = subject.first.month
        subject.each do |seal|
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
    subject { validated_contract_seals.seals }
    before {
      # Set all seal true and set nickname and date,
      # then random 3 seals are set sealed_flag to false
      subject.each do |seal|
        seal.sealed_flag = true
        seal.staff_nickname = validated_contract_seals.staff_nickname
        seal.sealed_date = validated_contract_seals.contract_date
      end
      subject.sample(3).each { |seal| seal.sealed_flag = false }
      SealParamsSetup.before_update(validated_contract_seals)
    }

    context "with true sealed_flag" do
      it "keeps sealed_date and staff_nickname." do
        subject.select{|s| s.sealed_flag}.each do |seal| 

          expect(seal.sealed_date).
            to eq(validated_contract_seals.contract_date)
          expect(seal.staff_nickname).
            to eq(validated_contract_seals.staff_nickname)
        end
      end
    end

    context "with false sealed_flag" do
      it "sets sealed_date and staff_nickname to nil." do
        subject.select{|s| !s.sealed_flag}.each do |seal| 
          expect(seal.sealed_date).to eq(nil)
          expect(seal.staff_nickname).to eq(nil)
        end
      end
    end
  end
end
