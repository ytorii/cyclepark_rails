require 'rails_helper'

RSpec.describe SealsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Seal. As you add validations to Seal, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SealsController. Be sure to keep this updated too.
  let(:valid_session) { {staff: '1'} }
  let(:first) {create(:first)}
  let(:first_contract) {build(:first_contract)}

  before{
    create(:admin)
  }

  describe "GET #index" do
    it "assigns all seals as @seals" do
      seal = Seal.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:seals)).to eq([seal])
    end
  end

  describe "GET #show" do
    it "assigns the requested seal as @seal" do
      seal = Seal.create! valid_attributes
      get :show, {:id => seal.to_param}, valid_session
      expect(assigns(:seal)).to eq(seal)
    end
  end

  describe "GET #new" do
    it "assigns a new seal as @seal" do
      get :new, {}, valid_session
      expect(assigns(:seal)).to be_a_new(Seal)
    end
  end

  describe "GET #edit" do
    it "assigns the requested seal as @seal" do
      get :edit, {:id => seal.to_param}, valid_session
      expect(assigns(:seal)).to eq(seal)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Seal" do
        expect {
          post :create, {:seal => valid_attributes}, valid_session
        }.to change(Seal, :count).by(1)
      end

      it "assigns a newly created seal as @seal" do
        post :create, {:seal => valid_attributes}, valid_session
        expect(assigns(:seal)).to be_a(Seal)
        expect(assigns(:seal)).to be_persisted
      end

      it "redirects to the created seal" do
        post :create, {:seal => valid_attributes}, valid_session
        expect(response).to redirect_to(Seal.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved seal as @seal" do
        post :create, {:seal => invalid_attributes}, valid_session
        expect(assigns(:seal)).to be_a_new(Seal)
      end

      it "re-renders the 'new' template" do
        post :create, {:seal => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    before{
      first_contract.leaf = first
      first_contract.save!
    }

    context "with valid params" do
      let(:new_attributes) {
        {
          sealed_flag: true,
          sealed_date: "2016-02-28",
          staff_nickname: "admin"
        }
      }

      it "updates the requested seal" do
        seal = Seal.where(sealed_flag: false).first 
        put :update, {:leaf_id => first.id, :contract_id => first_contract.id, :id => seal.to_param, :seal => new_attributes}, valid_session
        seal.reload

        expect(seal.sealed_flag).to eq(true)
        expect(seal.sealed_date).to eq(Date.parse("2016-02-28"))
        expect(seal.staff_nickname).to eq("admin")
      end

      it "assigns the requested seal as @seal" do
        seal = Seal.where(sealed_flag: false).first 
        put :update, {:leaf_id => first.id, :contract_id => first_contract.id, :id => seal.to_param, :seal => new_attributes}, valid_session
        seal.reload

        expect(assigns(:seal)).to eq(seal)
      end

      it "redirects to the seal" do
        seal = Seal.where(sealed_flag: false).first 
        put :update, {:leaf_id => first.id, :contract_id => first_contract.id, :id => seal.to_param, :seal => new_attributes}, valid_session
        seal.reload

        expect(response).to redirect_to(leaf_path(first.id))
      end
    end

    context "with invalid params" do
      it "assigns the seal as @seal" do
        seal = Seal.create! valid_attributes
        put :update, {:id => seal.to_param, :seal => invalid_attributes}, valid_session
        expect(assigns(:seal)).to eq(seal)
      end

      it "re-renders the 'edit' template" do
        seal = Seal.create! valid_attributes
        put :update, {:id => seal.to_param, :seal => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested seal" do
      seal = Seal.create! valid_attributes
      expect {
        delete :destroy, {:id => seal.to_param}, valid_session
      }.to change(Seal, :count).by(-1)
    end

    it "redirects to the seals list" do
      seal = Seal.create! valid_attributes
      delete :destroy, {:id => seal.to_param}, valid_session
      expect(response).to redirect_to(seals_url)
    end
  end

end
