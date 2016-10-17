require 'rails_helper'

RSpec.describe MultiSealsUpdateController, type: :controller do

  before :all do
    create_list(:count_first_normal_1, 3)
    create(:count_first_normal_2)
  end 

  shared_examples "routes to #index" do |session|
    before{
      # The date of the factorygirl's data is fixed,
      # so change the date with Timecop.
      Timecop.freeze('2016-06-03'.to_date)
      get :index, {}, session
    }

    it "returns http success." do
      expect(response).to have_http_status(:success)
    end

    it "returns number_sealsid_list as @list." do
      list = NumberSealsidListSearch.new.result
      expect(assigns(:list)).to eq(list)
    end

    it "returns multi_seals_update as @multi_seals_update." do
      expect(assigns(:multi_seals_update).sealed_date)
      .to eq(Date.current)
      expect(assigns(:multi_seals_update).staff_nickname)
      .to eq(session[:nickname])
    end

    after {
      # Restore the time as current.
      Timecop.return
    }
  end

  shared_examples "routes to #search" do |session|
    let(:index_valid_params){
      { number_sealsid_list_search:
        { vhiecle_type: '1',
          month: '2016-06-25',
          sealed_flag: 'false' }
      }
    }

    let(:index_invalid_params){
      { number_sealsid_list_search:
        { vhiecle_type: '4',
          month: 'a',
          sealed_flag: nil }
      }
    }

    shared_examples 'checks http status and page' do
      it 'returns http success.' do
        expect(response).to have_http_status(:success)
      end

      it 'renders index page.' do
        expect(response).to render_template(:index)
      end
    end

    context 'with valid params' do
      before{ post :search, index_valid_params, session }

      it_behaves_like 'checks http status and page'

      it 'returns number_sealsid_list as @list.' do
        list = NumberSealsidListSearch.new(
          index_valid_params[:number_sealsid_list_search]
        ).result

        expect(assigns(:list)).to eq(list)
      end
    end

    context 'with invalid params' do
      before{ post :search, index_invalid_params, session }

      it_behaves_like 'checks http status and page'

      it "returns flash alert message." do
        expect(flash.now[:alert]).to be_present
      end

      it 'returns empty number_sealsid_list as @list.' do
        expect(assigns(:list).size).to eq(0)
      end
    end
  end

  shared_examples "updates multi seals" do |session|

    let(:update_valid_params){
      { multi_seals_update: {
        staff_nickname: session[:nickname],
        sealed_date: "2016-06-03",
        sealsid_list: [ 3, 6 ] }
      }
    }

    let(:update_invalid_params){
      { multi_seals_update: {
        staff_nickname: session[:nickname],
        sealed_date: 'あ',
        sealsid_list: [ 3, 6 ] }
      }
    }

    context "with valid params" do
      let(:list){ update_valid_params[:multi_seals_update][:sealsid_list] }

      before{ post :update, update_valid_params, session }

      it "update Seals with selected ids." do
        # Pop blank id in the last of list(this is added by rails' tag)
        list.pop

        list.each do |id|
          seal = Seal.find(id)
          expect(seal.sealed_flag).to eq(true)
          expect(seal.staff_nickname).to eq(session[:nickname])
          expect(seal.sealed_date).to eq( Date.parse("2016-06-03") )
        end
      end

      it "unchange Seals with unselected ids."do
        unselected_ids = Seal.all.pluck(:id) - list

        unselected_ids.each do |id|
          seal = Seal.find(id)
          expect(seal.sealed_flag).to eq(false)
          expect(seal.staff_nickname).to eq(nil)
          expect(seal.sealed_date).to eq(nil)
        end
      end
    end

    context "with invalid param" do
      before{ post :update, update_invalid_params, session }
      it "returns http redirect." do
        expect(response).to have_http_status(:redirect)
      end

      it "returns flash alert message." do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #index" do
    context "with admin staff" do
      it_behaves_like "routes to #index", { staff: '1', nickname: 'admin' }
    end

    context "with normal staff" do
      it_behaves_like "routes to #index", { staff: '2', nickname: 'normal' }
    end
  end

  describe "POST #search" do
    context "with admin staff" do
      it_behaves_like "routes to #search", { staff: '1', nickname: 'admin' }
    end

    context "with normal staff" do
      it_behaves_like "routes to #search", { staff: '2', nickname: 'normal' }
    end
  end

  describe "POST #update" do
    context "with admin staff" do
      it_behaves_like "updates multi seals", { staff: '1', nickname: 'admin' } end

    context "with normal staff" do
      it_behaves_like "updates multi seals", { staff: '2', nickname: 'normal' }
    end
  end
end
