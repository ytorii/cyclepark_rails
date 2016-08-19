require 'rails_helper'

feature "Leaf search by number" do

  describe 'Searching the leaf by number' do

    # Leafs' number list in random order
    let(:leaf_numbers){[ 8, 9, 3, 4, 7, 10, 2, 1, 6, 5]}

    before{
      leaf_numbers.each do |leaf_number|
        # Create leaf and customer. (contracts are not needed)
        leaf = create(:first, number: leaf_number)
      end

      login("admin", "12345678")
    }

    context 'with valid input' do
      it 'successes to show the selected leaf.' do
        leaf_num = 10
        expect(current_path).to eq('/menu')

        within('#number_form') do
          find('.custom_rd_label', :text => '１号地').click
          fill_in 'number_input', with: leaf_num
          click_button '探す'
        end
        #page.save_screenshot('/home/pi2_test/multi_seals_update.png')

        # DB record's id starts with 1, so index + 1 is id value.
        expect(current_path).to eq(
          "/leafs/#{leaf_numbers.find_index(leaf_num) + 1}")
      end
    end

    context 'with invalid input' do
      it 'fails to show the selected leaf with empty input.' do
        within('#number_form') do
          click_button '探す'
        end

        expect(current_path).to eq('/menu')
        within(".alert-danger") do
          expect(page).to have_css('li',
            text: '契約番号を入力してください')
        end
      end

      it 'fails to show the selected leaf with non-exist number.' do
        leaf_num = 12

        within('#number_form') do
          find('.custom_rd_label', :text => '１号地').click
          fill_in 'number_input', with: leaf_num
          click_button '探す'
        end

        expect(current_path).to eq('/menu')
        within(".alert-danger") do
          expect(page).to have_css('li',
            text: '指定したリーフは存在しません。')
        end
      end
    end
  end
end
