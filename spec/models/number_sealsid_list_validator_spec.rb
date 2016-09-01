require 'rails_helper'

RSpec.describe NumberSealsidListValidator, type: :model do
  let(:validator){ build(:number_sealsid_list_validator)}

  describe 'vhiecle_type_eq' do
    [*1..3].each do |value|
      context "with #{value}." do
        it 'is valid' do
          validator.vhiecle_type_eq = value
          expect(validator).to be_valid
        end
      end
    end

    [0, 3.5, 4, 'a', 'あ'].each do |value|
      context "with #{value}." do
        it 'is invalid' do
          validator.vhiecle_type_eq = value
          expect(validator).not_to be_valid
          expect(validator.errors[:vhiecle_type_eq]).to be_present
        end
      end
    end
  end

  describe 'valid_flag_eq' do
    [true, false].each do |value|
      context "with #{value}." do
        it 'is valid' do
          validator.valid_flag_eq = value
          expect(validator).to be_valid
        end
      end
    end

    ['a', 'あ', 0, 1, nil].each do |value|
      context "with #{value}." do
        it 'is invalid' do
          validator.valid_flag_eq = value
          expect(validator).not_to be_valid
          expect(validator.errors[:valid_flag_eq]).to be_present
        end
      end
    end
  end

  describe "contracts_seals_month_eq" do
    ['2000/01/01', '2000-01-01', '2099/12/01'].each do |value|
      context "with #{value}" do
        it 'is valid.' do
          validator.contracts_seals_month_eq = value
          expect(validator).to be_valid
        end
      end
    end

    ['1999/12/31', '2100/01/01', '', 'あ'].each do |value|
      context "with #{value}" do
        it 'is invalid.' do
          validator.contracts_seals_month_eq = value
          expect(validator).not_to be_valid
          expect(validator.errors[:contracts_seals_month_eq]).to be_present
        end
      end
    end
  end

  describe 'contracts_seals_sealed_flag_eq' do
    [true, false].each do |value|
      context "with #{value}." do
        it 'is valid' do
          validator.contracts_seals_sealed_flag_eq = value
          expect(validator).to be_valid
        end
      end
    end

    ['a', 'あ', 0, 1, nil].each do |value|
      context "with #{value}." do
        it 'is invalid' do
          validator.contracts_seals_sealed_flag_eq = value
          expect(validator).not_to be_valid
          expect(validator.errors[:contracts_seals_sealed_flag_eq]).
            to be_present
        end
      end
    end
  end
end
