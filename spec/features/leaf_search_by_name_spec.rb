require 'rails_helper'

feature "Leaf search by name" do

  describe 'Searching the leaf by name' do

    before(:all){
      # Create leaf and customer. (contracts are not needed)
      5.times { create(:first) }
      2.times { create(:student) }
      2.times { create(:bike) }
      create(:second)
    }

    before(:each) { login("admin", "12345678") }

    context 'with valid input' do
      let(:leaf_id){ 5 }
      it 'successes  to show the list of leafs and jump to the leaf.' do
        within('#name_form') do
          fill_in_val 'name_input', with: '自転車'
          click_button '探す'
        end

        expect(current_path).to eq('/leafs_search')

        within('tbody') do
          all('a', text: '詳細を見る').last.click
        end

        # Wait until the page moves to the linked page.
        sleep 1

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
