require 'rails_helper'

RSpec.describe LeafsSearchController, type: :controller do

  let(:number_params){
    { :q =>
      { :number_eq => number,
        :vhiecle_type_eq => vtype,
        :valid_flag_eq => valid_flag
      }
    }
  }

  let(:name_params){
    { :q => { :customer_first_name_or_customer_last_name_cont => name } }
  }

  let(:noleaf_error_message){ ['指定したリーフは存在しません。'] }
  let(:nil_name_error_message){ ['名前またはフリガナを入力してください'] }
  let(:invalid_number_error_message){
    [ '契約種別は1以上の値にしてください',
      '契約番号は1056以下の値にしてください',
      '契約状態は一覧にありません' ]
  }

  before :all do
    create(:daily_first_nrm_1) 
    create(:daily_first_std_1) 
    create(:daily_bike_1) 
    create(:daily_large_bike_1) 
    create_list(:daily_second_1, 5, number: 10, valid_flag: false) 
    create(:daily_first_nrm_2) 
  end

  shared_examples  'gets leafs search index page' do |session|
    context 'with number search' do
      before { get :index, number_params, session }

      context 'with valid param' do
        context 'with empty result' do
          let(:number){ '1056' }
          let(:vtype){ '1' }
          let(:valid_flag){ 'true' }

          it 'redirects to the menu page.' do
            expect(response).to redirect_to("/menu")
          end

          it 'returns flash alert message.' do
            expect(flash[:alert]).to eq(noleaf_error_message)
          end
        end

        context 'with single search result' do
          let(:number){ "#{Leaf.all.first.number}" }
          let(:vtype){ '1' }
          let(:valid_flag){ 'true' }

          it 'redirects to the leaf page directly.' do
            expect(response).to redirect_to("/leafs/1")
          end
        end

        context 'with multiple search result' do
          let(:number){ '10' }
          let(:vtype){ '3' }
          let(:valid_flag){ 'false' }

          it 'renders the leaf search index page.' do
            expect(response.status).to eq(200)
            expect(response).to render_template :index
          end
        end
      end

      context 'with invalid param' do
        let(:number){ '10000' }
        let(:vtype){ '0' }
        let(:valid_flag){ 'あ' }

        it 'redirect to menu page.' do
          expect(response).to redirect_to('/menu')
        end

        it 'returns flash alert message.' do
          expect(flash[:alert]).to eq(invalid_number_error_message)
        end
      end
    end

    context 'with name search' do
      before { get :index, name_params, session }

      context 'with valid param' do
        context 'with empty result' do
          let(:name){ 'empty' }

          it 'redirects to the menu page.' do
            expect(response).to redirect_to("/menu")
          end

          it 'returns flash alert message.' do
            expect(flash[:alert]).to eq(noleaf_error_message)
          end
        end

        context 'with single search result' do
          let(:name){ '学生' }

          it 'redirects to the leaf page directly.' do
            expect(response).to redirect_to("/leafs/2")
          end
        end

        context 'with multiple search result' do
          let(:name){ '自転車' }

          it 'renders the leaf search index page.' do
            expect(response.status).to eq(200)
            expect(response).to render_template :index
          end
        end
      end

      context 'with invalid param' do
        let(:name){ nil }

        it 'redirect to menu page.' do
          expect(response).to redirect_to('/menu')
        end

        it 'returns flash alert message.' do
          expect(flash[:alert]).to eq(nil_name_error_message)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'with admin staff' do
      it_behaves_like 'gets leafs search index page', {staff: '1'}
    end

    context 'with normal staff' do
      it_behaves_like 'gets leafs search index page', {staff: '2'}
    end
  end
end
