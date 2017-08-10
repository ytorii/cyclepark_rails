require 'rails_helper'

feature "Customer Registration" do

  shared_examples "customer creation" do |nickname, password|
    before {
      login(nickname, password)
      click_link '新規契約の登録'
    }

    context "with valid input" do

      %w{ first student bike large_bike second }.each do |customer|
        it "successes to register a #{customer} customer", :js => true do
          leaf = build(customer)
          fill_leaf_form('form#new_leaf', leaf)
          click_button '登録する'

          expect(page.current_path).to eq("/leafs/1") 
          expect(page).to have_css('.alert-success', text: '顧客情報を登録しました。')
        end
      end
    end

    context "with invalid input" do
      it "fails to register new customer" do
        click_button '登録する'

        within("#error_explanation") do
          expect(page).to have_selector('li', text: "契約番号を入力してください")
          expect(page).to have_selector('li', text: "契約種別を入力してください")
          expect(page).to have_selector('li', text: "利用開始日を入力してください")
          expect(page).to have_selector('li', text: "姓を入力してください")
          expect(page).to have_selector('li', text: "名を入力してください")
          expect(page).to have_selector('li', text: "性別は一覧にありません")
          expect(page).to have_selector('li', text: "固定電話番号を入力してください")
          expect(page).to have_selector('li', text: "住所を入力してください")
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
    fill_in_val 'leaf_number', with: new_leaf.number
    case new_leaf.vhiecle_type
    when 1
      find('.custom_rd_label', :text => '１号地').click
    when 2
      find('.custom_rd_label', :text => 'バイク').click
    when 3
      find('.custom_rd_label', :text => '２号地').click
    end
    check 'leaf_student_flag' if new_leaf.student_flag
    check 'leaf_largebike_flag' if new_leaf.largebike_flag
    fill_in_val 'leaf_start_date', with: new_leaf.start_date
    fill_in_val 'leaf_customer_attributes_first_name', with: new_leaf.customer.first_name
    fill_in_val 'leaf_customer_attributes_last_name', with: new_leaf.customer.last_name
    fill_in_val 'leaf_customer_attributes_first_read', with: new_leaf.customer.first_read
    fill_in_val 'leaf_customer_attributes_last_read', with: new_leaf.customer.last_read
    if new_leaf.customer.sex
      find('.custom_rd_label', :text => '男性').click
    else
      find('.custom_rd_label', :text => '女性').click
    end
    fill_in_val 'leaf_customer_attributes_address', with: new_leaf.customer.address
    fill_in_val 'leaf_customer_attributes_phone_number', with: new_leaf.customer.phone_number
    fill_in_val 'leaf_customer_attributes_cell_number', with: new_leaf.customer.cell_number
    fill_in_val 'leaf_customer_attributes_receipt', with: new_leaf.customer.receipt
    fill_in_val 'leaf_customer_attributes_comment', with: new_leaf.customer.comment
  end
end
