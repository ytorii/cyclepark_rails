require 'rails_helper'

feature "Contract Edit" do

  let(:first){ create(:first) }
  let(:first_contract){ build(:first_contract) }
  let(:contract_id){ Contract.all.last.id }

  describe "Edit and delete contracts" do
    before{
      month = first.start_date
      5.times do 
        tmp_contract =
          build(:first_contract_add, start_month: month, leaf: first)
        tmp_contract.save! 
        month = month.next_month
      end
    }

    context "with admin staff" do
      before{ 
        login("admin", "12345678")
        visit "/leafs/#{first.id}"
      }

      it "successes to edit a contract." do
        click_link '契約の変更・削除'
        expect(current_path).to eq("/leafs/#{first.id}/contracts")

        within('#contracts_index') do
          all('a', text: '編集').last.click
        end

        expect(current_path).to eq(
          "/leafs/#{first.id}/contracts/#{contract_id}/edit")

        fill_in_val 'contract_contract_date', with: '2016-09-01'
        fill_in_val 'contract_money1', with: 3000
        fill_in_val 'contract_staff_nickname', with: 'normal'

        click_button '更新する'

        expect(current_path).to eq("/leafs/#{first.id}")
        expect(page).to have_css(
          '.alert-success', text: '契約が変更されました。')
        expect(page).to have_css('.contract_box.stamped', count: 5)
        expect(page).to have_css('.contract_box.stamped',
                                 text: "6 月 9/1 normal \\3,000")
      end

      it "successes to delete a contract.", :js => true do
        trigger_link('契約の変更・削除')

        expect(current_path).to eq("/leafs/#{first.id}/contracts")

        within('#contracts_index') do
          trigger_link('削除')
        end

        expect(current_path).to eq("/leafs/#{first.id}")
        expect(page).to have_css(
          '.alert-success', text: '契約が削除されました。')
        expect(page).to have_css('.contract_box.stamped', count: 4)
      end
    end

    context "with normal staff" do
      before{
        login("normal", "abcdefgh")
        visit '/leafs/1'
      }

      it "no links to edit page." do
        expect(page).not_to have_css('a', text: '契約の変更・削除')
      end

      it "redirects to login page by directly access to the edit page." do
        visit '/leafs/1/contracts/edit'

        expect(current_path).to eq("/login")
        expect(page).to have_css('p.error',
                                 text: '管理者としてログインして下さい。')
      end
    end
  end
end
