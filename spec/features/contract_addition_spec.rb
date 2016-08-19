require 'rails_helper'

feature "Contract Addition" do

  let(:today){ Date.today.strftime('%-m/%-d') }
  let(:leaf){ create(:first) }

  shared_examples "contract addition" do |nickname, password|
    before {
      login(nickname, password)
      visit "/leafs/#{leaf.id}"
      open_contadd_modal
    }

    context 'with opening contract addition modal' do
      scenario 'Fill the price to 3500 by selecting term １ヶ月.' do
        # Show the contract addition modal.
        expect(page).to have_css('h4', text: '契約更新画面' )

        # Term2 fields are invisible by default.
        expect(page).not_to have_css('#term2')

        # Fill the price to 3500 by selecting term １ヶ月.
        click_term(1, 1)
        expect(getvalue_script('#contract_money1')).to eq('3500')

        # Close the modal form by 閉じる button.
        find('#contadd_close_btn').click
        expect(page).not_to have_css('h4', text: '契約更新画面' )
      end
    end

    context 'with normal contract for 3 months' do
      scenario 'Add new contract succeccfully.' do
        # By default, 通常契約 is selected.
        click_term(1, 3)
        check 'contract_seals_attributes_0_sealed_flag'

        # Fill the money1 to 9500 by selecting term.
        expect(page.find_field('contract_money1').value).to eq('9500')

        within("form#new_contract") do
          click_button '登録する'
        end

        expect(page).to have_css(
          '.alert-success', text: '新規契約を登録しました。')
        expect(page).to have_css('.contract_box.stamped', count: 3)
        expect(page).to have_css('.contract_box.stamped',
                                 text: "4 月 #{today} #{nickname} \\9,500")
        expect(page).to have_css('.seal_box.stamped', count: 1)
        expect(page).to have_css('.seal_box.stamped',
                                 text: "#{today} 貼済 #{nickname}")
        expect(page.find_button('3月分貼付')[:value]).to eq('3月分貼付')
      end
    end

    context 'with way contract for 7 months' do
      scenario 'Add new contract succeccfully.' do
        find('.custom_rd_label', text: '中途契約').click
        click_term(1, 1)
        fill_in 'contract_money1', with: 1200
        click_term(2, 6)

        # Fill the money2 to 18000 by selecting term.
        expect(page.find_field('contract_money1').value).to eq('1200')
        expect(page.find_field('contract_money2').value).to eq('18000')

        click_button '登録する'

        expect(page).to have_css('.alert-success',
                                 text: '新規契約を登録しました。')
        expect(page).to have_css('.contract_box.stamped', count: 7)
        expect(page).to have_css('.contract_box.stamped',
                                 text: "2 月 #{today} #{nickname} \\1,200")
        expect(page).to have_css('.contract_box.stamped',
                                 text: "8 月 #{today} #{nickname} \\18,000")
        expect(page).to have_css('.seal_box.stamped', count: 0)
        expect(page.find_button('2月分貼付')[:value]).to eq('2月分貼付')
      end
    end

    context 'with skip contract' do
      scenario 'Add skip contract succeccfully.' do
        find('.custom_rd_label', text: '休み').click

        # Both term1 and term2 fields are invisible.
        expect(page).not_to have_css('#term1')
        expect(page).not_to have_css('#term2')

        click_button '登録する'

        expect(page).to have_css('.alert-success',
                                 text: '新規契約を登録しました。')
        expect(page).to have_css('.contract_box.stamped', text: '休み')
        expect(page).to have_css('.seal_box', text: 'シール未貼')
      end
    end

    context 'with sequential contracts input' do
      scenario 'Add sequential contracts succeccfully.' do
        # Add a new contract for 1 month. 
        find('.custom_rd_label', text: '通常契約').click
        click_term(1, 1)
        check 'contract_seals_attributes_0_sealed_flag'
        click_button '登録する'
        # Waiting for the Rails action
        sleep 1

        # Add a skip contract.
        open_contadd_modal
        find('.custom_rd_label', text: '休み').click
        click_button '登録する'
        # Waiting for the Rails action
        sleep 1

        # Add a way contract for 4 month.
        open_contadd_modal
        find('.custom_rd_label', text: '中途契約').click
        click_term(1, 1)
        fill_in 'contract_money1', with: 1200
        click_term(2, 3)
        check 'contract_seals_attributes_0_sealed_flag'
        click_button '登録する'

        expect(page).to have_css('.alert-success',
                                 text: '契約を更新しました。')
        expect(page).to have_css('.contract_box.stamped', count: 6)
        expect(page).to have_css('.contract_box.stamped',
                                 text: "2 月 #{today} #{nickname} \\3,500")
        expect(page).to have_css('.contract_box.stamped',
                                 text: "7 月 #{today} #{nickname} \\9,500")
        expect(page).to have_css('.seal_box.stamped', count: 2)
        expect(page.find_button('5月分貼付')[:value]).to eq('5月分貼付')
      end
    end

    context 'with invalid input' do
      scenario 'Fail to add a ccontract.' do
        click_button '登録する' 

        within(".alert-danger") do
          expect(page).to have_css('li',
            text: '契約期間は0より大きい値にしてください')
          expect(page).to have_css('li', text: '金額を入力してください')
        end
      end
    end
  end

  describe 'Adding contracts to the leaf' do
    context "by admin staff", :js => true  do
      it_behaves_like 'contract addition', 'admin', '12345678'
    end

    context "by normal staff", :js => true do
      it_behaves_like 'contract addition', 'normal', 'abcdefgh'
    end
  end
end

def click_term(index, length)
  case length
  when 1 term = '１ヶ月'
  when 3 term = '３ヶ月'
  when 6 term = '６ヶ月'
  end

  within("div#term#{index}") do
    find('.custom_rd_label', text: term).click
  end

  # Waiting for ajax action to fill the money depending on term length.
  sleep 1
end

# As the money set by ajax is not refletted to the DOM tree,
# javascript script os needed to get the money value 
def getvalue_script(attribute)
  page.evaluate_script("$('#{attribute}').val()")
end

def open_contadd_modal
  find('.add_cont_btn', text: '契約の更新').click
  # Waiting for the modal opened
  sleep 1
end
