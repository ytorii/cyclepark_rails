require 'rails_helper'

RSpec.describe "staffs/edit", type: :view do
  before(:each) do
    @staff = assign(:staff, Staff.create!(
      :nickname => "MyString",
      :password => "MyString",
      :admin_flag => false
    ))
  end

  it "renders the edit staff form" do
    render

    assert_select "form[action=?][method=?]", staff_path(@staff), "post" do

      assert_select "input#staff_nickname[name=?]", "staff[nickname]"

      assert_select "input#staff_password[name=?]", "staff[password]"

      assert_select "input#staff_admin_flag[name=?]", "staff[admin_flag]"
    end
  end
end
