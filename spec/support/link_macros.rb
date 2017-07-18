module LinkMacros
  def trigger_link(in_text)
    find('a', text: in_text).click
    # Waiting for completing click by javascript (not by Capybara!)
    sleep 1
  end

  def trigger_last_link(in_text)
    all('a', text: in_text).last.click
    # Waiting for completing click by javascript (not by Capybara!)
    sleep 1
  end
end
