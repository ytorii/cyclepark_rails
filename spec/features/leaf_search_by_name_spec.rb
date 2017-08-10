require 'rails_helper'

feature "Leaf search by name" do

  describe 'Searching the leaf by name' do

    before{
      # Create leaf and customer. (contracts are not needed)
      5.times { create(:first) }
      2.times { create(:student) }
      2.times { create(:bike) }
      create(:second)

      login("admin", "12345678")
    }

    context 'with valid input' do
      it 'successes  to show the list of leafs and jump to the leaf.' do
        leaf_id = 5

        within('#name_form') do
          fill_in_val 'name_input', with: '自転車'
          click_button '探す'
        end

        expect(current_path).to eq('/leafs_search')

        within('tbody') do
          expect(page).to have_css('tr', count: 5)
          all('a', text: '詳細を見る')[leaf_id - 1].click
        end

        expect(current_path).to eq("/leafs/#{leaf_id}")
      end
    end

    context 'with invalid input' do
      it 'fails to show the selected leaf with non-exist number.' do
        within('#name_form') do
          fill_in_val 'name_input', with: 'ssssss'
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
