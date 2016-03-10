require 'rails_helper'

RSpec.describe Staff, type: :model do
  let(:admin){ build(:admin) }

  specify 'Valid object' do
    expect(admin).to be_valid
  end

  specify "Generated salt length is 20 and password length is 40. " do
    admin.save!
    expect(admin.salt.size).to eq(20)
    expect(admin.password.size).to eq(40)
  end

  specify "nickname must be umique" do
    create(:admin2) 
    expect(admin).not_to be_valid
    expect(admin.errors[:nickname]).to be_present
  end

  specify "nickname must be less than 11 words." do
    admin[:nickname] = 'ア' * 11
    expect(admin).not_to be_valid
    expect(admin.errors[:nickname]).to be_present
  end

  specify "password must be more than 8 words." do
    admin[:password] = 'a' * 7
    expect(admin).not_to be_valid
    expect(admin.errors[:password]).to be_present
  end

  specify "password must be less than 16 words." do
    admin[:password] = 'a' * 17
    expect(admin).not_to be_valid
    expect(admin.errors[:password]).to be_present
  end

  specify "password must be alphabets or numbers." do
    admin[:password] = 'あ'
    expect(admin).not_to be_valid
    expect(admin.errors[:password]).to be_present
  end

end

RSpec.describe Staff, '.authenticate' do
  let(:admin){ create(:admin)}
  specify "Return Staff object matched with nickname and password." do
    
    # As admin.password is already digested, raw password is needed.
    result = Staff.authenticate(admin.nickname, "12345678")
    expect(result).to eq(admin)
  end
end
