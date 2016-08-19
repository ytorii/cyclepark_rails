require 'rails_helper'

RSpec.describe MenuController, type: :controller do

  let(:valid_session) { {staff: '1'} }
  let(:invalid_session) { {staff: nil} }

  describe "GET #index" do

    context "with logined session" do
      it "returns http success." do
        get :index, {}, valid_session
        expect(response).to have_http_status(:success)
      end
    end

    context "with unlogined session" do
      it "redirects to login page." do
        get :index, {}, invalid_session
        expect(response.status).to eq(302)
        expect(response).to redirect_to("/login")
      end
    end
  end
end
