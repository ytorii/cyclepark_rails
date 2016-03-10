require 'rails_helper'

describe 'ログイン' do
  before { 
    create(:admin) 
    create(:admindetail)
  }

  specify 'Redirect any page to login page without logged in ' do
    visit "/staffs"
    expect(page).to have_css('form#login')
  end

  specify 'Success logging in with correct nickname and correct password and redirect to the accessed page.' do
    visit "/staffs"
    within('form#login') do
      fill_in 'nickname', with: 'admin'
      fill_in 'password', with: '12345678'
      click_button 'ログイン'
    end
    expect(page).to have_css('h1', text: 'Listing Staffs')
  end

  specify 'Fail to log in with correct nickname and wrong password.' do
    visit "/staffs"
    within('form#login') do
      fill_in 'nickname', with: 'admin'
      fill_in 'password', with: 'wrong_password'
      click_button 'ログイン'
    end
    expect(page).to have_css('p.error', text: 'ユーザ名／パスワードが間違っています。')
    expect(page).to have_css('form#login')
  end

  specify 'Fail to log in with invalid nickname.' do
    visit "/staffs"
    within('form#login') do
      fill_in 'nickname', with: 'nostaff'
      fill_in 'password', with: 'any_string'
      click_button 'ログイン'
    end
    expect(page).to have_css('p.error', text: 'ユーザ名／パスワードが間違っています。')
    expect(page).to have_css('form#login')
  end

  specify 'Success logging out after logged in.' do
    visit "/staffs"
    within('form#login') do
      fill_in 'nickname', with: 'admin'
      fill_in 'password', with: '12345678'
      click_button 'ログイン'
    end
    visit "/login/logout"
    expect(page).to have_css('form#login')
    visit "/staffs"
    expect(page).to have_css('form#login')
  end
end
