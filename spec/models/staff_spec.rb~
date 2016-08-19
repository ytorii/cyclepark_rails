require 'rails_helper'

RSpec.describe Staff, type: :model do
  let(:test){ build(:test) }
  let(:test2){ build(:test2) }

  specify 'Valid object' do
    expect(test).to be_valid
  end

  specify "Generated salt length is 20 and password length is 40. " do
    test.save!
    expect(test.salt.size).to eq(20)
    expect(test.password.size).to eq(40)
  end

  specify "nickname must be unique" do
    create(:test2)
    expect(test2).not_to be_valid
    expect(test2.errors[:nickname]).to be_present
  end

  specify "nickname must be less than 11 words." do
    test[:nickname] = 'ア' * 11
    expect(test).not_to be_valid
    expect(test.errors[:nickname]).to be_present
  end

  specify "password must be more than 8 words." do
    test[:password] = 'a' * 7
    expect(test).not_to be_valid
    expect(test.errors[:password]).to be_present
  end

  specify "password must be less than 16 words." do
    test[:password] = 'a' * 17
    expect(test).not_to be_valid
    expect(test.errors[:password]).to be_present
  end

  specify "password must be alphabets or numbers." do
    test[:password] = 'あ'
    expect(test).not_to be_valid
    expect(test.errors[:password]).to be_present
  end

  specify "Return Staff object matched with nickname and password." do
    test.save!

    # As test.password is already digested, raw password is needed.
    result = Staff.authenticate(test.nickname, "12345678")
    expect(result).to eq(test)
  end
end
