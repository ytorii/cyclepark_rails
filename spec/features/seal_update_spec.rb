require 'rails_helper'

feature "Seal State Update" do
  describe 'Seal Update' do

    before{
      # create staffs
      create(:admin) 
      # create leaf and customer
      leaf = create(:first)
      # create contract and seal
      contract = build(:first_contract, leaf: leaf)
      contract.save 

      login("admin", "12345678")
      visit "/leafs/#{leaf.id}"
    }

    it 'updates unsticked seal to sticked.' do

      click_button '03月分シール貼付'
      
      check_message3 = '03月貼済 ' + Date.today.strftime("%m/%d") + " admin"

      expect(page).to have_css('p#notice', text: 'シール貼付情報を更新しました。')
      expect(page).to have_css('td', text: '02月貼済 02/20 admin' )
      expect(page).to have_css('td', text: check_message3 )
      expect(page).to have_button '04月分シール貼付' 

    end
  end
end
