require 'rails_helper'

RSpec.describe LeafLastDateUpdator do
  let(:leaf){ build(:first, id: 1) }
  let(:contract_with_seals){ build(:first_contract_no_callbacks_seals, leaf_id: leaf.id, leaf: leaf) }
  let(:seals){ contract_with_seals.seals }

  describe ".after_create" do
    subject { leaf.last_date }

    before { LeafLastDateUpdator.after_create(contract_with_seals) }

    it "updates leaf's last_date to contract's last day." do
      is_expected.
        to eq(seals.last.month.end_of_month)
    end
  end

  describe ".after_destroy" do
    subject { leaf.last_date }
    context "when leaf has contract" do
      before {
        # leaf's last_date and last contract's month is different
        leaf.last_date = seals.last.month.end_of_month + 1.months
        # This contract and one more contract existed before destroy.
        leaf.contracts_count = 2
        LeafLastDateUpdator.after_destroy(contract_with_seals)
      }

      it "updates leaf's last_date to contract's last month." do
        is_expected.to eq(contract_with_seals.start_month.last_month.end_of_month)
      end
    end

    context "when leaf has no contract" do
      before {
        leaf.last_date = seals.last.month.end_of_month + 1.months
        # Only this contract existed before destroy.
        leaf.contracts_count = 1
        LeafLastDateUpdator.after_destroy(contract_with_seals)
      }
      it "updates leaf's last_date to nil." do
        is_expected.to eq(nil)
      end
    end
  end
end
