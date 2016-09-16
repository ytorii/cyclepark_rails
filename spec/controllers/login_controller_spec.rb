require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let(:referer){ '/menu' }

  let(:admin_params){ 
    {nickname: 'admin', password: '12345678', referer: referer}
  }
  let(:normal_params){ 
    {nickname: 'normal', password: 'abcdefgh', referer: referer}
  }
  let(:invalid_params){ 
    {nickname: 'nostaff', password: 'wrong', referer: referer}
  }

  shared_examples 'gets login index page' do |session|
    it 'returns http success.' do
      get :index, {}, session
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    context 'with admin staff' do
      it_behaves_like 'gets login index page', { staff: 1 }
    end

    context 'with normal staff' do
      it_behaves_like 'gets login index page', { staff: 2 }
    end
  end

  describe 'POST #auth' do
    context 'with admin params' do
      before{ post :auth, admin_params, { staff: 1 } }

      it 'redirects to referer url.' do
        expect(response).to redirect_to(referer)
      end
      it 'registers session values correctly.' do
        expect(session[:nickname]).to eq(admin_params[:nickname])
        expect(session[:staff]).to eq(1)
      end
    end

    context 'with normal params' do
      before{ post :auth, normal_params, { staff: 2 } }

      it 'redirects to referer url.' do
        expect(response).to redirect_to(referer)
      end
      it 'registers session values correctly.' do
        expect(session[:nickname]).to eq(normal_params[:nickname])
        expect(session[:staff]).to eq(2)
      end
    end

    context 'with invalid params' do
      it 'rerenders index page.' do
        post :auth, invalid_params, { staff: 2 }
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #logout' do
    before{
      post :auth, admin_params, { staff: 1 } 
      get :logout, {}, { staff: 1 } 
    }

    it 'redirects to login index page.' do
      expect(response).to redirect_to('/login')
    end

    it 'resets session data.' do
      expect(response).to redirect_to('/login')
      expect(session.empty?).to eq(true) 
    end
  end
end
