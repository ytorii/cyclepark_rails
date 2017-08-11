require 'rails_helper'

feature "Customer Edit" do

  shared_examples "customer edit" do |nickname, password|
    let(:edit_leaf){ build(:student, number: 100) }

    before {
      create(:first) 
      login(nickname, password)

      visit '/leafs/1'
      clicklink_by_text_script('顧客情報変更')
    }

    context "with valid input" do
      scenario "successed to edit a customer" do
        expect(current_path).to eq("/leafs/1/edit")

        fill_leaf_form(page.all('#edit_leaf_1')[0], edit_leaf)
        click_button '更新する'
        expect(page).to have_css('.alert-success', text: '顧客情報を変更しました。')
      end
    end

    context "with invalid input" do
      scenario "failed to edit a customer" do
        expect(current_path).to eq("/leafs/1/edit")

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

def fill_leaf_form(form_id, edit_leaf)
  within(form_id) do
    fill_in_val 'leaf_number', with: edit_leaf.number
    case edit_leaf.vhiecle_type
    when 1
      find('.custom_rd_label', :text => '１号地').click
    when 2
      find('.custom_rd_label', :text => 'バイク').click
    when 3
      find('.custom_rd_label', :text => '２号地').click
    end
    check 'leaf_student_flag' if edit_leaf.student_flag
    check 'leaf_largebike_flag' if edit_leaf.largebike_flag
    fill_in_val 'leaf_start_date', with: '2016-02-01'
    fill_in_val 'leaf_customer_attributes_first_name', with: edit_leaf.customer.first_name
    fill_in_val 'leaf_customer_attributes_last_name', with: edit_leaf.customer.last_name
    fill_in_val 'leaf_customer_attributes_first_read', with: edit_leaf.customer.first_read
    fill_in_val 'leaf_customer_attributes_last_read', with: edit_leaf.customer.last_read
    if edit_leaf.customer.sex
      find('.custom_rd_label', :text => '男性').click
    else
      find('.custom_rd_label', :text => '女性').click
    end
    fill_in_val 'leaf_customer_attributes_address', with: edit_leaf.customer.address
    fill_in_val 'leaf_customer_attributes_phone_number', with: edit_leaf.customer.phone_number
    fill_in_val 'leaf_customer_attributes_cell_number', with: edit_leaf.customer.cell_number
    fill_in_val 'leaf_customer_attributes_receipt', with: edit_leaf.customer.receipt
    fill_in_val 'leaf_customer_attributes_comment', with: edit_leaf.customer.comment
  end
end
