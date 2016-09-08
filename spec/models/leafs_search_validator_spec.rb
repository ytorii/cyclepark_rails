require 'rails_helper'

RSpec.describe LeafsSearchValidator, type: :model do
  let(:validator){ build(:leafs_search_validator)}

  describe 'Number search' do
    describe 'vhiecle_type_eq' do
      ['1', '2', '3'].each do |value|
        context "with #{value.to_s}." do
          it 'is valid' do
            validator.vhiecle_type_eq = value
            expect(validator).to be_valid
          end
        end
      end

      [0, 3.5, 4, 'a', 'あ'].each do |value|
        context "with #{value.to_s}." do
          it 'is invalid' do
            validator.vhiecle_type_eq = value
            expect(validator).not_to be_valid
            expect(validator.errors[:vhiecle_type_eq]).to be_present
          end
        end
      end
    end

    describe "number_eq" do
      [1, 500, 1056].each do |value|
        context "with #{value.to_s}." do
          it 'is valid' do
            validator.number_eq = value
            expect(validator).to be_valid
          end
        end
      end

      [0, 1057, 3.5, 'a', 'あ'].each do |value|
        context "with #{value.to_s}." do
          it 'is invalid' do
            validator.number_eq = value
            expect(validator).not_to be_valid
            expect(validator.errors[:number_eq]).to be_present
          end
        end
      end
    end

    describe 'valid_flag_eq' do
      ['true', 'false'].each do |value|
        context "with #{value.to_s}." do
          it 'is valid' do
            validator.valid_flag_eq = value
            expect(validator).to be_valid
          end
        end
      end

      ['a', 'あ', 0, 1, nil].each do |value|
        context "with #{value.to_s}." do
          it 'is invalid' do
            validator.valid_flag_eq = value
            expect(validator).not_to be_valid
            expect(validator.errors[:valid_flag_eq]).to be_present
          end
        end
      end
    end

    describe 'customer_first_name_or_customer_last_name_cont' do
      [ 'あ', nil ].each do |value|
        context "with #{value.to_s}." do
          it 'is valid' do
            validator.customer_first_name_or_customer_last_name_cont = value
            expect(validator).to be_valid
          end
        end
      end
    end
  end

  describe 'Nmae search' do
    before{
      validator.number_eq = nil
      validator.vhiecle_type_eq = nil
      validator.valid_flag_eq = nil
    }

    describe 'customer_first_name_or_customer_last_name_cont' do
      ['a', 'あ', 0, 1].each do |value|
        context "with #{value.to_s}." do
          it 'is valid' do
            validator.customer_first_name_or_customer_last_name_cont = value
            expect(validator).to be_valid
          end
        end
      end

      context "with nil." do
        it 'is invalid' do
          validator.customer_first_name_or_customer_last_name_cont = nil
          expect(validator).not_to be_valid
          expect(validator.errors[
            :customer_first_name_or_customer_last_name_cont
          ]).to be_present
        end
      end
    end
  end
end
