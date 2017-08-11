require 'rails_helper'

feature "Multi Seals Update" do

  # Leafs' number list in random order
  let(:leaf_numbers){[ 8, 9, 3, 4, 7, 10, 2, 1, 6, 5]}

  before {
    leaf_numbers.each do |leaf_number|
      # create leaf and customer
      leaf = create(
        :first, number: leaf_number, start_date: Date.today.next_month)
      # create contract and seal
      contract = build(:first_contract_false, leaf: leaf)
      contract.save 
    end

    login('admin', '12345678')
    visit '/multi_seals_update'
  }

  describe 'search unsticked seals', :js => true do
    context 'with valid params' do
      before {
        leaf_numbers[0..5].each do |leaf_number|
          # create leaf and customer
          leaf = create(
            :second, number: leaf_number, start_date: Date.today.next_month)
          # create contract and seal
          contract = build(:first_contract_false, leaf: leaf)
          contract.save 
        end
      }

      it 'shows the list of numbers of selected month.' do
        expect(current_path).to eq('/multi_seals_update')

        within('form#new_number_sealsid_list_search') do
          find('.custom_rd_label', :text => '２号地').click
          fill_in_val 'number_sealsid_list_search_month',
            with: Date.today.next_month
        end
        click_button 'シール未貼付け番号を表示'

        expect(current_path).to eq('/multi_seals_update')

        within('form#new_multi_seals_update') do
          # Assert the numbers buttons are sorted by number ASC.
          arr = []
          all('.number_btn').map{|btn| arr << btn.text.to_i}
          expect(arr).to eq(leaf_numbers[0..5].sort)
        end
        #page.save_screenshot('/home/pi2_test/multi_seals_update.png')
      end
    end
    context 'with invalid params' do
      it 'shows the error messages and empty list.' do
        expect(current_path).to eq('/multi_seals_update')

        within('form#new_number_sealsid_list_search') do
          fill_in_val 'number_sealsid_list_search_month',
            with: Date.parse('1900-01-01')
        end
        click_button 'シール未貼付け番号を表示'

        expect(page).not_to have_css('.number_btn')
        expect(page).to have_css(
          '.alert-danger', text: 'シール貼付け対象月は不正な値です')
      end
    end
  end

  describe 'updates multiple Seals' do
    # JavaScript is needed to pass the test!
    context 'with valid input', :js => true do
      it 'updates unsealed seal to be sealed.' do
        expect(current_path).to eq('/multi_seals_update')

        within('form#new_multi_seals_update') do
          # Assert the numbers buttons are sorted by number ASC.
          arr = []
          all('.number_btn').map{|btn| arr << btn.text.to_i}
          expect(arr).to eq(leaf_numbers.sort)

          0.upto(4) do |i|
            find('.number_btn', text: /#{leaf_numbers[i].to_s}/).click
          end

          click_button 'シール貼付け処理'
        end

        expect(current_path).to eq('/menu')
        visit "/multi_seals_update"

        # Assert the unselectd numbers are left.
        arr = []
        all('.number_btn').map{ |btn| arr << btn.text.to_i }
        expect(arr).to eq(leaf_numbers[5..-1].sort)
      end
    end

    context 'with invalid input' do
      it 'fail to update seals.' do
        within('form#new_multi_seals_update') do
          fill_in_val 'multi_seals_update_sealed_date', with: nil
          click_button 'シール貼付け処理'
        end

        expect(current_path).to eq('/multi_seals_update')
        within(".alert-danger") do
          expect(page).to have_css('li',
            text: 'シール貼付け作業日を入力してください')
          expect(page).to have_css('li',
            text: '契約番号リストが選択されていません。')
        end
      end
    end
  end
end
