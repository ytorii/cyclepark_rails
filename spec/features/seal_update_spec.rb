require 'rails_helper'

feature "Seal State Update" do
  describe 'Seal Update', :js => true do

    before{
      # create leaf and customer
      leaf = create(:first)
      # create contract and seal
      contract = build(:first_contract, leaf: leaf)
      contract.save 

      login("admin", "12345678")
      visit "/leafs/#{leaf.id}"
    }

    it 'updates unsticked seal to be sticked.' do

      expect(page).to have_css('.seal_box.stamped', count: 1)

      click_button '3月分貼付'
      today = Date.today.strftime('%-m/%-d')
      
      expect(page).to have_css(
        '.alert-success', text: 'シール貼付情報を更新しました。')
      expect(page).to have_css('.seal_box.stamped', count: 2)
      expect(page).to have_css('.seal_box.stamped',
                               text:"#{today} 貼済 admin")
      expect(page).to have_button '4月分貼付' 
    end
  end
end
