require 'rails_helper'

RSpec.describe CountContractsSummaryController, type: :controller do

  before :all do
    create(:count_first_normal_1) 
    create(:count_first_normal_2) 
    create(:count_first_normal_3) 
    create(:count_first_student_1) 
    create(:count_bike_1) 
    create(:count_largebike_1) 
    create(:count_second_1) 
    create(:count_second_2) 
  end 

  after :all do
    seed_tables = %w{ staffs staffdetails }
    DatabaseCleaner.clean_with(:truncation, {:except => seed_tables})
  end

  shared_examples "gets count contracts summary index page" do |session|
    before{ get :index, {count_month: nil}, session }

    it "returns http success." do
      expect(response).to have_http_status(:success)
    end

    it "assigns contracts count summary as @count." do

      expected_hash = {
        "present_total" => [1, 1, 2, 1, 0, 1, 1],
        "present_new"   => [0, 1, 1, 0, 0, 0, 1],
        "next_total"    => [2, 0, 2, 0, 1, 1, 1],
        "next_new"      => [1, 0, 1, 0, 0, 0, 1],
        "diffs_prev"    => [0, 1, 1, 0, -1, -1, 1],
        "next_unpaid"   => [0, 1, 1, 1, 0, 1, 1]
      }

      month = Date.parse('2016-06-01')
      counts = CountContractsSummary.new(month).count_contracts_summary
      expect(counts).to eq(expected_hash)
    end
  end

  describe "GET #index" do
    context "with admin staff" do
      context "with valid input" do
        it_behaves_like "gets count contracts summary index page",
          {staff: '1'}
      end

      context "with invalid input" do
      before{ get :index, {count_month: 'あ'}, {staff: '1'} }
        it "redirect to menu page." do
          expect(response).to redirect_to("/menu")
        end
      end
    end

    context "with normal staff" do
      before{ get :index, {count_month: nil}, {staff: '2'} }
      it "redirect to login page." do
        expect(response).to redirect_to("/login")
      end
    end
  end
end
