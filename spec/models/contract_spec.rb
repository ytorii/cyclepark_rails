require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:first){ create(:first) }
  let(:first_contract){ build(:first_contract, leaf_id: first.id) }
  let(:first_contract_add){ build(:first_contract_add, leaf_id: first.id) }

  before{ first }

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

  { term1: 12, money1: 36000, term2: 9, money2: 18000}.each do |key, value|
    describe "#{key}" do
      it "is valid with #{value}." do
        first_contract[key] = value
        expect(first_contract).to be_valid
      end

      it "is invalid with #{value + 1}." do
        first_contract[key] = value + 1
        expect(first_contract).not_to be_valid
        expect(first_contract.errors[key]).to be_present
      end
    end
  end

  %w{term1 money1}.each do |column|
    describe "#{column}" do
      it "is invalid with nil" do
        first_contract[column] = nil
        expect(first_contract).not_to be_valid
      end
    end
  end

  %w{term2 money2}.each do |column|
    describe "#{column}" do
      it "is valid with nil" do
        first_contract[column] = nil
        expect(first_contract).to be_valid
      end
    end
  end


  describe "skip_flag" do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first_contract[:skip_flag] = value
          expect(first_contract).to be_valid
        end
      end
    end
  end

  describe "staff_nickname" do
    it "is valid with nickanme in Staffs DB." do
      expect(first_contract).to be_valid
    end

    it "is invalid with nickanme NOT in Staffs DB." do
      first_contract[:staff_nickname] = 'nostaff'
      expect(first_contract).not_to be_valid
      expect(first_contract.errors[:staff_nickname]).to be_present
    end
  end

  describe "term1 and term2" do
    before { first_contract.save! }

    context "with unchanged terms" do
      before{ first_contract.update(term1: 1) }
      it "is valid." do
        expect(first_contract).to be_valid
      end
    end

    context "with changed term1." do
      before{ first_contract.update(term1: 3)}
      it "is invalid" do
        expect(first_contract).not_to be_valid
      end
    end

    context "with changed term2." do
      before{ first_contract.update(term2: 3)}
      it "is invalid" do
        expect(first_contract).not_to be_valid
      end
    end
  end

  describe ".set_skipcontract_params" do
    context "with skip_flag is true" do
      before {
        first_contract.skip_flag = true
        first_contract.send(:set_skipcontract_params)
      }

      { term1: 1, money1: 0, term2: 0, money2: 0}.each do |key, value|
        it "sets #{key} to #{value}" do
          expect(first_contract[key]).to eq(value)
        end
      end
    end
  end

  describe ".set_nilcontract_params" do
    [false, nil].each do |value|
      context "with skip_flag is #{value.to_s}" do
        before {
          first_contract.skip_flag = value
          first_contract.term2 = nil
          first_contract.money2 = nil
          first_contract.send(:set_nilcontract_params)
        }

        it "sets skip_flag to false" do
          expect(first_contract.skip_flag).to eq(false)
        end

        ["term2", "money2"].each do |column|
          it "sets nil #{column} to 0" do
            expect(first_contract[column]).to eq(0)
          end
        end
      end
    end
  end

  describe ".set_contract_params" do
    context "with no contracts" do
      before { first_contract.send(:set_contract_params) }

      it "sets new_flag to true." do
        expect(first_contract.new_flag).to eq(true)
      end
      it "sets start_month to leaf's start_date." do
        expect(first_contract.start_month).to eq(first.start_date)
      end
    end

    context "with existed contracts" do
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

  end

  describe ".set_seals_params" do
    subject { first_contract.seals }

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

      it "sets seal's staff_nickname to contract's." do
        expect(subject.first.staff_nickname).to eq(first_contract.staff_nickname)
      end

      it "sets seal's sealed_date to contract's contract_date." do
        expect(subject.first.sealed_date).to eq(first_contract.contract_date)
      end

      it_behaves_like 'seals except the first seal'
    end

    %w{ false nil }.each do |param|
      context "with first sealed_flag #{param.to_s}" do
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
  end

  describe ".set_canceledseals_params" do
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

  describe ".update_leaf_lastdate" do
    subject { Leaf.find(first.id).last_date  }

    before {
      first_contract.send(:set_seals_params)
      first_contract.send(:update_leaf_lastdate)
    }

    it "updates leaf's last_date to contract's last month." do
      is_expected.to eq(first_contract.seals.last.month)
    end
  end

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

  describe ".backdate_leaf_lastdate" do
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

  describe "Seal's month" do
    before { first_contract.save! }

    context "when month is unique in the leaf." do
      it "is valid." do
        expect(first_contract_add).to be_valid
      end
    end

    context "when month is NOT unique in the leaf." do
      before{
        first.update(last_date: Date.parse("2016-02-20"))
        first_contract_add.valid?
      }

      it "is invalid." do
        expect(first_contract_add).not_to be_valid
      end

      it 'returns an error message.' do
        expect(first_contract_add.errors[:month]).to be_present
      end
    end
  end
end
