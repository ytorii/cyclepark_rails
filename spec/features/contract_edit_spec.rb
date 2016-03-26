require 'rails_helper'

feature "Contract Edit" do

  let(:admin){create(:admin)}
  let(:normal){create(:normal)}
  let(:first){create(:first)}
  let(:first_contract) {build(:first_contract)}

  shared_examples "access to the edit page" do
  end

  before{
    admin
    normal
    month = first.start_date
    5.times do 
      tmp_contract = build(:first_contract_add, start_month: month)
      tmp_contract.leaf = first
      tmp_contract.save! 
      month = month.next_month
    end

    login("admin", "12345678")
    visit '/leafs/1'
    click_link '契約の変更・削除'
  }

  describe "Access to contract edit page" do
    context "with admin staff" do
      it "successes to show the page." do
        expect(current_path).to eq("/leafs/1/contracts")
      end
    end

    context "with normal staff" do
      it "fails to show the page." do
        login("normal", "abcdefgh")
        visit '/leafs/1'
        click_link '契約の変更・削除'

        expect(current_path).to eq("/login")
        expect(page).to have_css('p.error', text: '管理者としてログインして下さい。')
      end
    end
  end

  describe "Contracts delete", focus: true do
    it "successes to show the page." do
      expect(current_path).to eq("/leafs/1/contracts")
    end
  end
end
