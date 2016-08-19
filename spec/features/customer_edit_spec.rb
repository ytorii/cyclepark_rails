require 'rails_helper'

feature "Customer Edit" do

  shared_examples "customer edit" do |nickname, password|
    before {
      create(:first) 
      login(nickname, password)

      visit '/leafs/1'
      click_link '顧客情報変更'
    }

    context "with valid input" do
      scenario "successed to edit a customer" do
        expect(current_path).to eq("/leafs/1/edit")

        edit_leaf = build(:student)
        edit_leaf.number = 100
        fill_leaf_form(page.all('#edit_leaf_1')[0], edit_leaf)
        click_button '更新する'
        expect(page).to have_css('.alert-success', text: '顧客情報を変更しました。')
      end
    end

    context "with invalid input" do
      scenario "failed to edit a customer" do
        expect(current_path).to eq("/leafs/1/edit")

        edit_leaf = build(:student)
        edit_leaf.number = ''
        fill_leaf_form(page.all('#edit_leaf_1')[0], edit_leaf)
        click_button '更新する'
        within("div#error_explanation") do
          expect(find('ul')).to have_selector('li', text: "契約番号を入力してください")
        end
      end
    end
  end

  describe "Admin staff" do
    it_behaves_like "customer edit", "admin", "12345678"
  end

  describe "Normal staff" do
    it_behaves_like "customer edit", "normal", "abcdefgh"
  end
end

def fill_leaf_form(form_id, new_leaf)
  within(form_id) do
    fill_in 'leaf_number', with: new_leaf.number
    choose "vtype_1"
    check 'leaf_student_flag' if new_leaf.student_flag
    check 'leaf_largebike_flag' if new_leaf.largebike_flag
    fill_in 'leaf_start_date', with: '2016-02-01'
    fill_in 'leaf_customer_attributes_first_name', with: new_leaf.customer.first_name
    fill_in 'leaf_customer_attributes_last_name', with: new_leaf.customer.last_name
    fill_in 'leaf_customer_attributes_first_read', with: new_leaf.customer.first_read
    fill_in 'leaf_customer_attributes_last_read', with: new_leaf.customer.last_read
    if new_leaf.customer.sex
      choose 'sex_male' 
    else
      choose 'sex_female' 
    end
    fill_in 'leaf_customer_attributes_address', with: new_leaf.customer.address
    fill_in 'leaf_customer_attributes_phone_number', with: new_leaf.customer.phone_number
    fill_in 'leaf_customer_attributes_cell_number', with: new_leaf.customer.cell_number
    fill_in 'leaf_customer_attributes_receipt', with: new_leaf.customer.receipt
    fill_in 'leaf_customer_attributes_comment', with: new_leaf.customer.comment
  end
end
