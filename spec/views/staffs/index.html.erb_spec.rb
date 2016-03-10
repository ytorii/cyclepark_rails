require 'rails_helper'

RSpec.describe "staffs/index", type: :view do
  before(:each) do
    assign(:staffs, [
      Staff.create!(
        :nickname => "Nickname",
        :password => "Password",
        :admin_flag => false
      ),
      Staff.create!(
        :nickname => "Nickname",
        :password => "Password",
        :admin_flag => false
      )
    ])
  end

  it "renders a list of staffs" do
    render
    assert_select "tr>td", :text => "Nickname".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
