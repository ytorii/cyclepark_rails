require 'rails_helper'

feature "Customer Edit" do

  before{
    create(:first)
    create(:student)
  }

  context "as an admin staff with valid input" do
    scenario "successed to edit a customer" do
      admin = create(:admin) 
      login("admin", "12345678")

      visit '/leafs/1'
      click_button '顧客情報変更'
      expect(current_path).to eq("/leafs/1/edit")

      edit_leaf = build(:student)
      edit_leaf.number = 100
      fill_leaf_form('form#edit_leaf_1', edit_leaf)
      click_button '更新する'
      expect(page).to have_css('p#notice', text: '顧客情報を変更しました。')
    end
  end

  context "as a normal staff with valid input" do
    scenario "successed to edit a customer" do
      normal = create(:normal) 
      login("normal", "abcdefgh")

      visit '/leafs/1'
      click_button '顧客情報変更'
      expect(current_path).to eq("/leafs/1/edit")

      edit_leaf = build(:student)
      edit_leaf.number = 100
      fill_leaf_form('form#edit_leaf_1', edit_leaf)
      click_button '更新する'
      expect(page).to have_css('p#notice', text: '顧客情報を変更しました。')
    end
  end

  context "with invalid input" do
    scenario "failed to register new customer" do
      admin = create(:admin) 
      login("admin", "12345678")

      visit '/leafs/1'
      click_button '顧客情報変更'
      expect(current_path).to eq("/leafs/1/edit")

      edit_leaf = build(:student)
      edit_leaf.number = ''
      fill_leaf_form('form#edit_leaf_1', edit_leaf)
      click_button '更新する'
      within("div#error_explanation") do
        expect(find('ul')).to have_selector('li', text: "契約番号を入力してください")
      end
    end
  end
end

def fill_leaf_form(form_id, new_leaf)
  within(form_id) do
    fill_in 'leaf_number', with: new_leaf.number
    choose "leaf_vhiecle_type_1"
    check 'leaf_student_flag' if new_leaf.student_flag
    check 'leaf_largebike_flag' if new_leaf.largebike_flag
    select "2016", from: "leaf_start_date_1i"
    select "2月", from: "leaf_start_date_2i"
    select "1", from: "leaf_start_date_3i"
    fill_in 'leaf_customer_attributes_first_name', with: new_leaf.customer.first_name
    fill_in 'leaf_customer_attributes_last_name', with: new_leaf.customer.last_name
    fill_in 'leaf_customer_attributes_first_read', with: new_leaf.customer.first_read
    fill_in 'leaf_customer_attributes_last_read', with: new_leaf.customer.last_read
    if new_leaf.customer.sex
      choose 'leaf_customer_attributes_sex_true' 
    else
      choose 'leaf_customer_attributes_sex_false'
    end
    fill_in 'leaf_customer_attributes_address', with: new_leaf.customer.address
    fill_in 'leaf_customer_attributes_phone_number', with: new_leaf.customer.phone_number
    fill_in 'leaf_customer_attributes_cell_number', with: new_leaf.customer.cell_number
    fill_in 'leaf_customer_attributes_receipt', with: new_leaf.customer.receipt
    fill_in 'leaf_customer_attributes_comment', with: new_leaf.customer.comment
  end
end
