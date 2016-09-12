require 'rails_helper'

RSpec.describe TermspriceController, type: :controller do
  let(:valid_params){ { leaf_id: 1, term: 3 } } 
  let(:invalid_params){ { leaf_id: 3, term: 100 } } 
  let(:json_body){ { 'price' => 9500 } }

  before :all do
    create(:first) 
  end 

  shared_examples 'gets terms price as json' do |session|
    context 'with valid param' do
      before do
        get :index, valid_params, session
      end

      it 'returns http success.' do
        expect(response).to have_http_status(:success)
      end

      it 'returns correct price.' do
        expect(JSON.parse(response.body)).to eq(json_body)
      end
    end

    context 'with invalid param' do
      before do
        get :index, invalid_params, session
      end

      it 'redirect to menu page.' do
        expect(response).to redirect_to('/menu')
      end

      it 'returns flash alert message.' do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #index' do
    context 'with admin staff' do
      it_behaves_like 'gets terms price as json', {staff: '1'}
    end

    context 'with normal staff' do
      it_behaves_like 'gets terms price as json', {staff: '2'}
    end
  end
end
