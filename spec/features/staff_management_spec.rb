require 'rails_helper'

describe 'Staff management feature' do
  let(:edit_account) {
    {   
      nickname: "test2",
      password: "abcdefghi",
      name: "テスト　ユーザ２",
      read: "テスト　ユーザニ",
      address: "寝屋川市八坂町１７－５",
      phone_number: "072-838-8888",
      cell_number: "090-4563-3333"
    }
  }

  let(:new_account) {
    {   
      nickname: "test",
      password: "abcdefgh",
      name: "テスト　ユーザ",
      read: "テスト　ユーザ",
      address: "寝屋川市八坂町１７－１",
      phone_number: "072-838-2058",
      cell_number: "090-4563-6103"
    }
  }

  describe 'Access control for staff management' do
    specify 'Accept access with admin nickname and password.' do
      login('admin', '12345678')
      visit "/staffs"
      expect(page).to have_css('h1', text: 'スタッフ一覧')
    end

    specify 'Deny access with normal nickname and password.' do
      login('normal', 'abcdefgh')
      visit "/staffs"
      expect(page).to have_css('form#login')
    end
  end

  describe 'GET show Staff' do
    before { login('admin', '12345678') } 

    context "Get index page" do
      it "Response index page" do
        visit "/staffs"
        expect(page).to have_css('h1', text: 'スタッフ一覧')
      end
    end

    context "Get detail page" do
      it "Response detail page" do
        visit "/staffs/1"
        expect(page).to have_css('p', text: '管理者 ユーザ')
      end
    end
  end

  describe 'POST create Staff' do
    before {
      login('admin', '12345678') 
      visit "/staffs/new"
    } 

    context "with valid inputs" do
      it "create the new staff." do
        fill_form('form#new_staff', new_account)
        click_button '登録する'

        expect(page).to have_css('p#notice', text: 'スタッフ情報を登録しました。')
      end
    end

    context "with empty inputs" do
      it "return error messages." do
        empty_form(new_account)
        fill_form('form#new_staff', new_account)
        click_button '登録する'

        within("div#error_explanation") do
          expect(find('ul')).to have_selector('li', text: "スタッフ名を入力してください")
          expect(find('ul')).to have_selector('li', text: "パスワードを入力してください")
          expect(find('ul')).to have_selector('li', text: "名前を入力してください")
          expect(find('ul')).to have_selector('li', text: "ふりがなを入力してください")
          expect(find('ul')).to have_selector('li', text: "住所を入力してください")
          expect(find('ul')).to have_selector('li', text: "固定電話番号を入力してください")
        end
      end
    end

    context "with illegal inputs" do
      it "return error messages." do
        new_account[:nickname] = "a" * 11
        new_account[:password] = "a"
        new_account[:name] = "a" * 21
        new_account[:read] = "a" * 41
        new_account[:address] = "a" * 51
        new_account[:phone_number] = "0" * 13
        new_account[:cell_number] = "0" * 13
        fill_form('form#new_staff', new_account)
        click_button '登録する'

        within("div#error_explanation") do
          expect(find('ul')).to have_selector('li', text: "スタッフ名は10文字以内で入力してください")
          expect(find('ul')).to have_selector('li', text: "パスワードは8文字以上で入力してください")
          expect(find('ul')).to have_selector('li', text: "名前は20文字以内で入力してください")
          expect(find('ul')).to have_selector('li', text: "ふりがなは40文字以内で入力してください")
          expect(find('ul')).to have_selector('li', text: "住所は50文字以内で入力してください")
          expect(find('ul')).to have_selector('li', text: "固定電話番号は12文字以内で入力してください")
          expect(find('ul')).to have_selector('li', text: "携帯電話番号は不正な値です")
        end
      end
    end
  end

  describe 'PUT update Staff' do
    before {
      login('admin', '12345678') 
      visit "/staffs/new"
      fill_form('form#new_staff', new_account)
      click_button '登録する'
      visit "/staffs/3/edit"
    }

    context "with valid inputs" do
      it "updates the requested staff." do
        fill_form('form#edit_staff_3', edit_account)
        select "2013", from: "staff_staffdetail_attributes_birthday_1i"
        select "3月", from: "staff_staffdetail_attributes_birthday_2i"
        select "3", from: "staff_staffdetail_attributes_birthday_3i"
        click_button '更新する'
        expect(page).to have_css('p#notice', text: 'スタッフ情報を更新しました。')
      end
    end

    context "with empty inputs" do
      it "return error messages." do
        empty_form(edit_account)
        fill_form('form#edit_staff_3', edit_account)
        click_button '更新する'

        within("div#error_explanation") do
          expect(find('ul')).to have_selector('li', text: "スタッフ名を入力してください")
          expect(find('ul')).to have_selector('li', text: "パスワードを入力してください")
          expect(find('ul')).to have_selector('li', text: "名前を入力してください")
          expect(find('ul')).to have_selector('li', text: "ふりがなを入力してください")
          expect(find('ul')).to have_selector('li', text: "住所を入力してください")
          expect(find('ul')).to have_selector('li', text: "固定電話番号を入力してください")
        end
      end
    end
  end

  describe 'DELETE delete Staff', focus: true do
    let(:new_account) {
      {   
        nickname: "test",
        password: "abcdefgh",
        name: "テスト　ユーザ",
        read: "テスト　ユーザ",
        address: "寝屋川市八坂町１７－１",
        phone_number: "072-838-2058",
        cell_number: "090-4563-6103"
      }
    }

    before { login('admin', '12345678') } 

    it "delete the selected staff", :js => true do
      visit "/staffs/new"
      fill_form('form#new_staff', new_account)
      click_button '登録する'
      visit "/staffs"

      # Wrapping the click method to accept 'OK' in the dialog
      accept_alert do
        all('a', text: '削除').last.click
      end

      expect(page).to have_css('p#notice', text: 'スタッフ情報を削除しました。')
    end
  end
end

def fill_form(form_id, input_account)
  within(form_id) do
    fill_in_val 'staff_nickname', with: input_account[:nickname]
    fill_in_val 'staff_password', with: input_account[:password]
    check '管理者フラグ'
    fill_in_val 'staff_staffdetail_attributes_name', with: input_account[:name]
    fill_in_val 'staff_staffdetail_attributes_read', with: input_account[:read]
    fill_in_val 'staff_staffdetail_attributes_address',
      with: input_account[:address]
    select "2014", from: "staff_staffdetail_attributes_birthday_1i"
    select "4月", from: "staff_staffdetail_attributes_birthday_2i"
    select "1", from: "staff_staffdetail_attributes_birthday_3i"
    fill_in_val 'staff_staffdetail_attributes_phone_number',
      with: input_account[:phone_number]
    fill_in_val 'staff_staffdetail_attributes_cell_number',
      with: input_account[:cell_number]
  end
end

def empty_form(input_account)
  input_account[:nickname] = ""
  input_account[:password] = ""
  input_account[:name] = ""
  input_account[:read] = ""
  input_account[:address] = ""
  input_account[:phone_number] = ""
  input_account[:cell_number] = ""
end
