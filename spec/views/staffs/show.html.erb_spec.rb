require 'rails_helper'

RSpec.describe "staffs/show", type: :view do
  before(:each) do
    @staff = assign(:staff, Staff.create!(
      :nickname => "Nickname",
      :password => "Password",
      :admin_flag => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nickname/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/false/)
  end
end
