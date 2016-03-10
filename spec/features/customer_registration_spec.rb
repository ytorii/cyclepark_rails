require 'rails_helper'

feature "Customer Registration" do

  before{
    create(:admin) 
    create(:normal) 
  }

  shared_examples "customer creation" do |nickname, password|
    context "with valid input" do
      %w{ first student bike large_bike second }.each do |customer|
        it "successes to register a #{customer} customer" do
          login(nickname, password)
          visit '/leafs/new'
          leaf = build(customer)
          fill_leaf_form('form#new_leaf', leaf)
          click_button '登録する'
          expect(page).to have_css('p#notice', text: '顧客情報を登録しました。')
        end
      end
    end

    context "with invalid input" do
      it "fails to register new customer" do
        login(nickname, password)
        visit '/leafs/new'
        click_button '登録する'
        within("div#error_explanation") do
          expect(find('ul')).to have_selector('li', text: "契約番号を入力してください")
          expect(find('ul')).to have_selector('li', text: "姓を入力してください")
          expect(find('ul')).to have_selector('li', text: "名を入力してください")
          expect(find('ul')).to have_selector('li', text: "セイを入力してください")
          expect(find('ul')).to have_selector('li', text: "メイを入力してください")
          expect(find('ul')).to have_selector('li', text: "住所を入力してください")
        end
      end
    end
  end

  describe "Admin staff" do
    it_behaves_like "customer creation", "admin", "12345678"
  end

  describe "Normal staff" do
    it_behaves_like "customer creation", "normal", "abcdefgh"
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
    select "2016", from: "leaf_start_date_1i"
    fill_in 'leaf_customer_attributes_address', with: new_leaf.customer.address
    fill_in 'leaf_customer_attributes_phone_number', with: new_leaf.customer.phone_number
    fill_in 'leaf_customer_attributes_cell_number', with: new_leaf.customer.cell_number
    fill_in 'leaf_customer_attributes_receipt', with: new_leaf.customer.receipt
    fill_in 'leaf_customer_attributes_comment', with: new_leaf.customer.comment
  end
end
