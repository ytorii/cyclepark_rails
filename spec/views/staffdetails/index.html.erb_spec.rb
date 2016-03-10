require 'rails_helper'

RSpec.describe "staffdetails/index", type: :view do
  before(:each) do
    assign(:staffdetails, [
      Staffdetail.create!(
        :staff => nil,
        :name => "Name",
        :read => "Read",
        :address => "Address",
        :phone_number => "Phone Number",
        :cell_number => "Cell Number"
      ),
      Staffdetail.create!(
        :staff => nil,
        :name => "Name",
        :read => "Read",
        :address => "Address",
        :phone_number => "Phone Number",
        :cell_number => "Cell Number"
      )
    ])
  end

  it "renders a list of staffdetails" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Read".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
    assert_select "tr>td", :text => "Cell Number".to_s, :count => 2
  end
end
