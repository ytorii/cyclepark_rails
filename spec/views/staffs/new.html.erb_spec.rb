require 'rails_helper'

RSpec.describe "staffs/new", type: :view do
  before(:each) do
    assign(:staff, Staff.new(
      :nickname => "MyString",
      :password => "MyString",
      :admin_flag => false
    ))
  end

  it "renders new staff form" do
    render

    assert_select "form[action=?][method=?]", staffs_path, "post" do

      assert_select "input#staff_nickname[name=?]", "staff[nickname]"

      assert_select "input#staff_password[name=?]", "staff[password]"

      assert_select "input#staff_admin_flag[name=?]", "staff[admin_flag]"
    end
  end
end
