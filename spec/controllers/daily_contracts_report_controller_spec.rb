require 'rails_helper'

RSpec.describe DailyContractsReportController, type: :controller do

  let(:report){ DailyContractsReport.new(
    contracts_date: '2016-01-16',
    query: DailyContractsQuery) }

  before do
    create(:daily_first_nrm_1) 
    create(:daily_first_std_1) 
    create(:daily_bike_1) 
    create(:daily_large_bike_1) 
    create(:daily_second_1) 
    create(:daily_first_nrm_2) 
  end 

  shared_examples "gets daily contract index page" do |session|
    context "with valid param" do
      before{ get :index, {:contracts_date => '2016-01-16'}, session }
      it "returns http success." do
        expect(response).to have_http_status(:success)
      end

      it "assigns contracts report as @report." do
        expect(assigns(:contracts_date)).to eq(report.contracts_date)
        expect(assigns(:contracts_list)).to eq(report.contracts_list)
        expect(assigns(:contracts_total)).to eq(report.contracts_total)
      end
    end

    context "with invalid param" do
      before{ get :index, {:contracts_date => 'あ'}, session }
      it "redirect to menu page." do
        expect(response).to redirect_to("/menu")
      end

      it "returns flash alert message." do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #index" do
    context "with admin staff" do
      it_behaves_like "gets daily contract index page", {staff: '1'}
    end

    context "with normal staff" do
      it_behaves_like "gets daily contract index page", {staff: '2'}
    end
  end
end
