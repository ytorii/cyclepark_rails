require 'rails_helper'

RSpec.describe "staffdetails/show", type: :view do
  before(:each) do
    @staffdetail = assign(:staffdetail, Staffdetail.create!(
      :staff => nil,
      :name => "Name",
      :read => "Read",
      :address => "Address",
      :phone_number => "Phone Number",
      :cell_number => "Cell Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Read/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Phone Number/)
    expect(rendered).to match(/Cell Number/)
  end
end
