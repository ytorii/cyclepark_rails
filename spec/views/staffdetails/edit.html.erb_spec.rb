require 'rails_helper'

RSpec.describe "staffdetails/edit", type: :view do
  before(:each) do
    @staffdetail = assign(:staffdetail, Staffdetail.create!(
      :staff => nil,
      :name => "MyString",
      :read => "MyString",
      :address => "MyString",
      :phone_number => "MyString",
      :cell_number => "MyString"
    ))
  end

  it "renders the edit staffdetail form" do
    render

    assert_select "form[action=?][method=?]", staffdetail_path(@staffdetail), "post" do

      assert_select "input#staffdetail_staff_id[name=?]", "staffdetail[staff_id]"

      assert_select "input#staffdetail_name[name=?]", "staffdetail[name]"

      assert_select "input#staffdetail_read[name=?]", "staffdetail[read]"

      assert_select "input#staffdetail_address[name=?]", "staffdetail[address]"

      assert_select "input#staffdetail_phone_number[name=?]", "staffdetail[phone_number]"

      assert_select "input#staffdetail_cell_number[name=?]", "staffdetail[cell_number]"
    end
  end
end
