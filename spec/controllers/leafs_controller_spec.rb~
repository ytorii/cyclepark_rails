require 'rails_helper'

RSpec.describe LeafsController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:first).merge({
      customer_attributes: attributes_for(:first_customer)
    })
  }

  let(:invalid_attributes) {
    attributes_for(:first, number: '').merge({
      customer_attributes: attributes_for(:first_customer)
    })
  }

  let(:new_attributes) {
    attributes_for(:second).merge({
      customer_attributes: attributes_for(:second_customer)
    })
  }

  let(:admin_session) { {staff: '1'} }
  let(:normal_session) { {staff: '2'} }

  let(:first) { create(:first, valid_flag: true ) }
  let(:first_invalid) { create(:first, valid_flag: false) }
  let(:contract) { build(:first_contract) }

  before{
    create(:admin)
    create(:normal)
  }

  describe "GET #index" do
    before { first }

    context "with admin staff" do
      it "assigns all leafs as @leafs." do
        get :index, {}, admin_session
        expect(assigns(:leafs)).to eq([first])
      end
    end

    context "with normal staff" do
      it "redirects to login page." do
        get :index, {}, normal_session
        expect(response.status).to eq(302)
        expect(response).to redirect_to("/login")
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested leaf as @leaf" do
      leaf = Leaf.create! valid_attributes
      get :show, {:id => leaf.to_param}, admin_session
      expect(assigns(:leaf)).to eq(leaf)
    end
  end

  describe "GET #new" do
    it "assigns a new leaf as @leaf" do
      get :new, {}, admin_session
      expect(assigns(:leaf)).to be_a_new(Leaf)
    end
  end

  describe "GET #edit" do
    it "assigns the requested leaf as @leaf" do
      leaf = Leaf.create! valid_attributes
      get :edit, {:id => leaf.to_param}, admin_session
      expect(assigns(:leaf)).to eq(leaf)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Leaf" do
        expect {
          post :create, {:leaf => valid_attributes}, admin_session
        }.to change(Leaf, :count).by(1).and change(Customer, :count).by(1)
      end

      it "assigns a newly created leaf as @leaf" do
        post :create, {:leaf => valid_attributes}, admin_session
        expect(assigns(:leaf)).to be_a(Leaf)
        expect(assigns(:leaf)).to be_persisted
      end

      it "redirects to the created leaf's page." do
        post :create, {:leaf => valid_attributes}, admin_session
        expect(response).to redirect_to(leaf_path(assigns(:leaf)))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved leaf as @leaf" do
        post :create, {:leaf => invalid_attributes}, admin_session
        expect(assigns(:leaf)).to be_a_new(Leaf)
      end

      it "re-renders the 'new' template" do
        post :create, {:leaf => invalid_attributes}, admin_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update for leaf and customer" do
    let(:leaf){Leaf.create! valid_attributes}

    context "with valid params" do
      it "updates the requested leaf." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, admin_session
        leaf.reload
        expect(leaf.vhiecle_type).to eq(3)
        expect(leaf.customer.comment).to eq("ベトナムより")
      end

      it "assigns the requested leaf as @leaf." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, admin_session
        expect(assigns(:leaf)).to eq(leaf)
      end

      it "redirects to the leaf's page." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, admin_session
        expect(response).to redirect_to(leaf_path(leaf.to_param))
      end
    end

    context "with invalid params" do
      it "assigns the leaf as @leaf" do
        put :update, {:id => leaf.to_param, :leaf => invalid_attributes}, admin_session
        expect(assigns(:leaf)).to eq(leaf)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => leaf.to_param, :leaf => invalid_attributes}, admin_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    context "with valid leaf" do
      before { first }

      context "with admin staff" do
        it "falis to destroy the requested leaf" do
          expect {
            delete :destroy, {:id => first.to_param}, admin_session
          }.to change(Leaf, :count).by(0)
        end

        it "redirects to the leafs list" do
          delete :destroy, {:id => first.to_param}, admin_session
          expect(response).to redirect_to(leafs_url)
        end
      end

      context "with normal staff" do
        it "redirects to login page." do
          get :index, {}, normal_session
          expect(response.status).to eq(302)
          expect(response).to redirect_to("/login")
        end
      end
    end

    context "with invalid leaf" do
      before {
        first_invalid 
        contract.leaf = first_invalid
        contract.seals.first.sealed_flag = true
        contract.save!
      }

      context "with admin staff" do
        it "destroys the requested leaf" do
          expect {
            delete :destroy, {:id => first_invalid.to_param}, admin_session
          }.to change(Leaf, :count).by(-1).and change(Customer, :count).by(-1).and change(Contract, :count).by(-1).and change(Seal, :count).by(-7)
        end

        it "redirects to the leafs list" do
          delete :destroy, {:id => first_invalid.to_param}, admin_session
          expect(response).to redirect_to(leafs_url)
        end
      end

      context "with normal staff" do
        it "redirects to login page." do
          get :index, {}, normal_session
          expect(response.status).to eq(302)
          expect(response).to redirect_to("/login")
        end
      end
    end
  end
end
