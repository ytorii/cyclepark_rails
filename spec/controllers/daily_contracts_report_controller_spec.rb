require 'rails_helper'

RSpec.describe DailyContractsReportController, type: :controller do

  before{
    create(:admin)
    create(:normal)
    create(:daily_first_nrm_1) 
    create(:daily_first_std_1) 
    create(:daily_bike_1) 
    create(:daily_large_bike_1) 
    create(:daily_second_1) 
    create(:daily_first_nrm_2) 
  }

  shared_examples "gets daily contract index page" do |session|
    before{ get :index, {:contract_date => '2016-01-16'}, session }
    it "returns http redirect." do
      expect(response).to have_http_status(:success)
    end

    it "assigns contracts report as @report." do
      report = DailyContractsReport.new('2016-01-16')
      expect(assigns(:report).contracts_date).to eq(report.contracts_date)
      expect(assigns(:report).contracts_list).to eq(report.contracts_list)
      expect(assigns(:report).contracts_total).to eq(report.contracts_total)
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
