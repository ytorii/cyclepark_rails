require 'rails_helper'

RSpec.describe LeafsSearchValidator, type: :model do
  describe 'validation' do
    context 'in number search' do
      before { allow(subject).to receive(:number_search?).and_return(true) }

      describe '#vhiecle_type_eq' do
        it { is_expected.to validate_presence_of(:vhiecle_type_eq) }
        it { is_expected.to validate_numericality_of(:vhiecle_type_eq).
             is_greater_than_or_equal_to(1).
             is_less_than_or_equal_to(3).
             only_integer.allow_nil }
      end

      describe "number_eq" do
        it { is_expected.to validate_presence_of(:number_eq) }
        it { is_expected.to validate_numericality_of(:number_eq).
             is_greater_than_or_equal_to(1).
             is_less_than_or_equal_to(1056).
             only_integer.allow_nil }
      end

      describe '#valid_flag_eq' do
        it { is_expected.to validate_inclusion_of(:valid_flag_eq).in_array([true, false])}
      end

      describe '#customer_first_name_or_customer_last_name_cont' do
        it { is_expected.
             to allow_value(nil).for(:customer_first_name_or_customer_last_name_cont) }
      end
    end

    context 'in name search' do
      before { allow(subject).to receive(:number_search?).and_return(false) }

      describe '#vhiecle_type_eq' do
        it { is_expected.to allow_value(nil).for(:vhiecle_type_eq) }
      end

      describe '#number_eq' do
        it { is_expected.to allow_value(nil).for(:number_eq) }
      end

      describe '#valid_flag_eq' do
        it { is_expected.to allow_value(nil).for(:valid_flag_eq) }
      end

      describe '#customer_first_name_or_customer_last_name_cont' do
        it { is_expected.
             to validate_presence_of(:customer_first_name_or_customer_last_name_cont) }
      end
    end
  end
end
