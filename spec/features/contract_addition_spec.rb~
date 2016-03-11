require 'rails_helper'

feature "Contract Addition" do

  before{
    # create staffs
    create(:admin) 
    # create leaf and customer
    leaf = create(:first)
    login("admin", "12345678")

    visit "/leafs/#{leaf.id}"
  }

  let(:register_with_valid_input){

    within("form#new_contract") do
      select "1ヶ月", from: "contract_term1"
      fill_in 'contract_money1', with: 500
      select "3ヶ月", from: "contract_term2"
      fill_in 'contract_money2', with: 9500
      select "2016", from: "contract_contract_date_1i"
      select "2月", from: "contract_contract_date_2i"
      select "1", from: "contract_contract_date_3i"
      uncheck 'contract_skip_flag'
      check 'contract_seals_attributes_0_sealed_flag'
    end
    click_button '登録する'

    expect(page).to have_css('p#notice', text: '新規契約を登録しました。')
    expect(page).to have_css('td', text: '2016/02' )
    expect(page).to have_css('td', text: '1' )
    expect(page).to have_css('td', text: '500' )
    expect(page).to have_css('td', text: '3' )
    expect(page).to have_css('td', text: '9500' )
    expect(page).to have_css('td', text: '02/01' )
    expect(page).to have_css('td', text: '新規' )
    expect(page).to have_css('td', text: 'admin' )
    expect(page).to have_css('td', text: '2月貼済 02/01 admin' )
    expect(page).to have_button '03月分シール貼付' 
  }

  let(:register_with_invalid_input){
    within("form#new_contract") do
      select "1ヶ月", from: "contract_term1"
      select "2016", from: "contract_contract_date_1i"
      select "2月", from: "contract_contract_date_2i"
      select "1", from: "contract_contract_date_3i"
      uncheck 'contract_skip_flag'
      uncheck 'contract_seals_attributes_0_sealed_flag'
    end
    click_button '登録する'

    within("div#error_explanation") do
      expect(find('ul')).to have_selector('li', text: "Money1を入力してください")
    end
  }

  describe 'New contract registration' do
    context "with valid input" do
      scenario 'successes to register new contract and seal to the leaf.' do
        register_with_valid_input
      end
    end

    context "with invalid input" do
      scenario 'fails to register new contract and seal to the leaf.' do
        register_with_invalid_input
      end
    end
  end

  describe 'Additional contract registration' do
    context "with valid input" do
      scenario "successes to add extended contract and seal to the leaf." do
        register_with_valid_input

        within("form#new_contract") do
          select "1ヶ月", from: "contract_term1"
          fill_in 'contract_money1', with: 3500
          select "2016", from: "contract_contract_date_1i"
          select "5月", from: "contract_contract_date_2i"
          select "31", from: "contract_contract_date_3i"
          uncheck 'contract_skip_flag'
          uncheck 'contract_seals_attributes_0_sealed_flag'
        end
        click_button '登録する'

        expect(page).to have_css('p#notice', text: '契約を更新しました。')
        expect(page).to have_css('td', text: '2016/06' )
        expect(page).to have_css('td', text: '1' )
        expect(page).to have_css('td', text: '3500' )
        expect(page).to have_css('td', text: '05/31' )
        expect(page).to have_css('td', text: '更新' )
        expect(page).to have_css('td', text: 'admin' )
        expect(page).to have_button '03月分シール貼付' 
      end
    end

    context "with invalid input" do
      scenario "fails to add extended contract and seal to the leaf." do
        register_with_valid_input
        register_with_invalid_input
      end
    end
  end
end
