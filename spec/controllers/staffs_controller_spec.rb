require 'rails_helper'

RSpec.describe StaffsController, type: :controller do

  let(:valid_attributes) {
    {   
      nickname: "test",
      password: "abcdefgh",
      admin_flag: false,
      staffdetail_attributes: {
        name: "テスト　ユーザ",
        read: "テスト　ユーザ",
        address: "寝屋川市八坂町１７－１",
        birthday: "2012-03-01",
        phone_number: "072-838-2058",
        cell_number: "090-4563-6103"
      }
    }
  }

  let(:invalid_attributes) {
    {   
      nickname: "",
      password: "abcdefgh",
      admin_flag: false,
      staffdetail_attributes: {
        name: "テスト　ユーザ",
        read: "テスト　ユーザ",
        address: "寝屋川市八坂町１７－１",
        birthday: "2012-03-01",
        phone_number: "072-838-2058",
        cell_number: "090-4563-6103"
      }
    }
  }



  let(:valid_session) { {staff: '1'} }

  describe 'Response for GET method.' do
    context "GET #index" do
      it "assigns the requested staff as @staff" do
        staff = Staff.find(1)
        get :index, {}, valid_session
        expect(response.status).to eq(200)
        expect(assigns(:staff)).to eq(staff)
        expect(response).to render_template :index
      end
    end

    context "GET #show" do
      it "assigns the requested staff as @staff" do
        staff = Staff.find(1)
        get :show, {:id => staff.to_param}, valid_session
        expect(response.status).to eq(200)
        expect(assigns(:staff)).to eq(staff)
        expect(response).to render_template :show
      end
    end

    context "GET #edit" do
      it "assigns the requested staff as @staff" do
        staff = Staff.find(1)
        expect(response.status).to eq(200)
        get :edit, {:id => staff.to_param}, valid_session
        expect(assigns(:staff)).to eq(staff)
      end
    end

    context "GET #new" do
      it "assigns a new staff as @staff" do
        get :new, {}, valid_session
        expect(response.status).to eq(200)
        expect(assigns(:staff)).to be_a_new(Staff)
        expect(response).to render_template :new
      end
    end
  end

  describe 'Response for POST method.' do
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Staff" do
          expect {
            post :create, {:staff => valid_attributes}, valid_session
          }.to change(Staff, :count).by(1)
        end

        it "assigns a newly created staff as @staff" do
          post :create, {:staff => valid_attributes}, valid_session
          expect(assigns(:staff)).to be_a(Staff)
          expect(assigns(:staff)).to be_persisted
        end

        it "redirects to the created staff" do
          post :create, {:staff => valid_attributes}, valid_session
          #By default, Rails responses 302 code for redirection.
          expect(response.status).to eq(302)
          expect(response).to redirect_to(Staff.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved staff as @staff" do
          post :create, {:staff => invalid_attributes}, valid_session
          expect(assigns(:staff)).to be_a_new(Staff)
        end

        it "re-renders the 'new' template" do
          post :create, {:staff => invalid_attributes}, valid_session
          expect(response.status).to eq(200)
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      let(:new_attributes) {
        {   
          nickname: "test2",
          password: "abcdefgh",
          admin_flag: false,
          staffdetail_attributes: {
            name: "テスト　ユーザ２",
            read: "テスト　ユーザニ",
            address: "寝屋川市八坂町１７－１",
            birthday: "2012-03-01",
            phone_number: "072-838-2058",
            cell_number: "090-4563-6103"
          }
        }
      }

      context "with valid params" do
        it "updates the requested staff" do
          staff = create(:test)
          put :update, {
            :id => staff.to_param, :staff => new_attributes
          }, valid_session
          staff.reload
          expect(staff.nickname).to eq("test2")
          expect(staff.staffdetail.name).to eq("テスト　ユーザ２")
        end

        it "assigns the requested staff as @staff" do
          staff = Staff.create! valid_attributes
          put :update, {:id => staff.to_param, :staff => new_attributes}, valid_session
          expect(assigns(:staff)).to eq(staff)
        end

        it "redirects to the staff" do
          staff = Staff.create! valid_attributes
          put :update, {:id => staff.to_param, :staff => new_attributes}, valid_session
          expect(response.status).to eq(302)
          expect(response).to redirect_to(staff)
        end
      end

      context "with invalid params" do
        it "assigns the staff as @staff" do
          staff = Staff.create! valid_attributes
          put :update, {:id => staff.to_param, :staff => invalid_attributes}, valid_session
          expect(assigns(:staff)).to eq(staff)
        end

        it "re-renders the 'edit' template" do
          staff = Staff.create! valid_attributes
          put :update, {:id => staff.to_param, :staff => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested staff and staffdetail" do
        staff = Staff.create! valid_attributes
        expect {
          delete :destroy, {:id => staff.to_param}, valid_session
        }.to change(Staff, :count).by(-1).and change(Staffdetail, :count).by(-1)
      end

      it "redirects to the staffs list" do
        staff = Staff.create! valid_attributes
        delete :destroy, {:id => staff.to_param}, valid_session
        expect(response).to redirect_to(staffs_url)
      end
    end
  end
end
