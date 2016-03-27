require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:first_customer){ build(:first_customer) }

  %w{first_read last_read}.each do |column|
    describe "#{column}" do

      it "accepts ｱｲｳ by replacing them to アイウ." do
        first_customer[column]= 'ｱｲｳ'
        expect(first_customer).to be_valid
      end

      it "accepts ひらがな by replacing them to カタカナ." do
        first_customer[column] = 'あいう'
        expect(first_customer).to be_valid
        expect(first_customer[column]).to eq('アイウ')
      end

      it "is invalid with except カタカナ." do
        ['亜', 'A', '1', '@'].each do |value|
          first_customer[column] = value
          expect(first_customer).not_to be_valid
          expect(first_customer.errors[column]).to be_present
        end
      end
    end
  end

  { first_name: 10, last_name: 10, first_read: 20, last_read: 20, address: 50, receipt: 50, comment: 100}.each do |key, value|
    describe "#{key}" do
      it "is valid with #{value} words." do
        first_customer[key] = 'あ' * value
        expect(first_customer).to be_valid
      end

      it "is invalid with #{value + 1} words." do
        first_customer[key] = 'あ' * (value + 1)
        expect(first_customer).not_to be_valid
        expect(first_customer.errors[key]).to be_present
      end
    end
  end

  describe 'Receipt' do
    it "is '不要' by default." do
      first_customer.save!
      expect(Customer.find(1).receipt).to eq('不要')
    end
  end

  describe 'Sex' do
    context 'is valid' do
      [true, false].each do |value|
        it "with #{value}." do
          first_customer[:sex] = value
          expect(first_customer).to be_valid
        end
      end
    end

    context 'is invalid' do
      [''].each do |value|
        it "with empty." do
          first_customer[:sex] = value
          expect(first_customer).not_to be_valid
          expect(first_customer.errors[:sex]).to be_present
        end
      end
    end
  end

  describe "Phone number and Cell number" do
    %w{ phone_number cell_number }.each do |column|
      context "#{column}" do
        it "is valid with empty when the other is filled in." do
          first_customer[column]= ''
          expect(first_customer).to be_valid
        end

        it "is invalid except Integer or '-'." do
          ['亜', 'あ', 'ア', 'A', '@'].each do |value|
            first_customer[column] = value
            expect(first_customer).not_to be_valid
            expect(first_customer.errors[column]).to be_present
          end
        end
      end
    end

    context "phone number" do
      it "is valid with 12 words" do
        first_customer[:phone_number] = '0' * 12
        expect(first_customer).to be_valid
      end

      it "is invalid with 13 words" do
        first_customer[:phone_number] = '0' * 13
        expect(first_customer).not_to be_valid
        expect(first_customer.errors[:phone_number]).to be_present
      end
    end

    context "cell number" do
      it "accepts only 000-0000-0000 form." do
        first_customer[:cell_number] = '0' * 13
        expect(first_customer).not_to be_valid
        expect(first_customer.errors[:cell_number]).to be_present
      end
    end
  end
end
