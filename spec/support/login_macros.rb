module LoginMacros
  def login(nickname, password)
    visit "/menu"
    within('form#login') do
      fill_in_val 'nickname', with: nickname
      fill_in_val 'password', with: password
      click_button 'ログイン'
    end
  end
end
