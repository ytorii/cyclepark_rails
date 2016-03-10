require 'rails_helper'

RSpec.describe Staffdetail, type: :model do
  let(:staffdetail){ build(:staffdetail) }

  specify 'Accept valid object' do
    expect(staffdetail).to be_valid
  end

  specify "Name must be less than 20 words." do
    staffdetail[:name] = 'あ' * 21
    expect(staffdetail).not_to be_valid
    expect(staffdetail.errors[:name]).to be_present
  end

  specify "Read must be less than 40 words." do
    staffdetail[:read] = 'ア' * 41
    expect(staffdetail).not_to be_valid
    expect(staffdetail.errors[:read]).to be_present
  end

  specify "Read must not include except カタカナ." do
    ['亜', 'A', '1', '@'].each do |value|
      staffdetail[:read] = value
      expect(staffdetail).not_to be_valid
      expect(staffdetail.errors[:read]).to be_present
    end
  end

  specify "Read accept ｱ by replacing it to ア." do
    staffdetail[:read]= 'ｱ'
    expect(staffdetail).to be_valid
  end

  specify "Read accept ひらがな by replacing them to カタカナ." do
    staffdetail[:read] = 'あいう'
    expect(staffdetail).to be_valid
    expect(staffdetail[:read]).to eq('アイウ')
  end

  specify "Address must be less than 50 words." do
    staffdetail[:address] = 'あ' * 51
    expect(staffdetail).not_to be_valid
    expect(staffdetail.errors[:address]).to be_present
  end

  specify "Accept empty phone_number with valid cell_number." do
    staffdetail[:phone_number]= ''
    expect(staffdetail).to be_valid
  end

  specify "Accept empty cell_number with valid phone_number." do
    staffdetail[:cell_number]= ''
    expect(staffdetail).to be_valid
  end

  %w{ phone_number cell_number }.each do |column_name|
    specify "#{column_name} accepts only Integer or '-'." do
      ['亜', 'あ', 'ア', 'A', '@'].each do |value|
        staffdetail[column_name] = value
        expect(staffdetail).not_to be_valid
        expect(staffdetail.errors[column_name]).to be_present
      end
    end
  end

  specify "Phone_number must be less than 12 words." do
    staffdetail[:phone_number] = '0' * 13
    expect(staffdetail).not_to be_valid
    expect(staffdetail.errors[:phone_number]).to be_present
  end

  specify "Cell_number accepts only 000-0000-0000 form." do
    staffdetail[:cell_number] = '0' * 13
    expect(staffdetail).not_to be_valid
    expect(staffdetail.errors[:cell_number]).to be_present
  end
end
