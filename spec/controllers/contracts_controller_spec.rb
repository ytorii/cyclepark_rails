require 'rails_helper'

RSpec.describe ContractsController, type: :controller do

  let(:valid_attributes) {
    {
      leaf_id: 1,
      contract_date: "2016-02-29",
      start_month: "",
      term1: 1,
      money1: 1000,
      term2: 6,
      money2: 18000,
      new_flag: '',
      skip_flag: false,
      staff_nickname: "admin",
      seals_attributes: [{
        sealed_flag: true
      }]
    }
  }

  let(:invalid_attributes) {
    {
      leaf_id: 1,
      contract_date: "2016-02-29",
      start_month: "2016-02-29",
      term1: '',
      money1: 1000 ,
      term2: 6,
      money2: 18000,
      new_flag: true,
      skip_flag: false,
      staff_nickname: "admin",
      seals_attributes: [{
        sealed_flag: true
      }]
    }
  }

  let(:valid_session) { {staff: '1', leaf_id: 1 } }
  let(:first) {create(:first)}

  before{
    create(:admin)
  }

  describe "GET #index", :focus => false do
    it "assigns all contracts as @contracts" do
      contract = Contract.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:contracts)).to eq([contract])
    end
  end

  describe "GET #show", :focus => false do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :show, {:id => contract.to_param}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "GET #edit", :focus => false do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :edit, {:id => contract.to_param}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "GET #new" do
    it "assigns @leaf from leaf_id in the request params." do
      get :new, { :leaf_id => 1 }, valid_session
      expect(assigns(:leaf).id).to eq(1)
    end

    it "assigns leaf_id in the request params to @contract." do
      get :new, { :leaf_id => 1 }, valid_session
      expect(assigns(:contract).leaf_id).to eq(1)
    end
  end

  describe "POST #create", :focus => true do
    context "with valid params" do
      it "creates one new Contract." do
        expect {
          post :create, {:contract => valid_attributes, :leaf_id => first.id}, valid_session
        }.to change(Contract, :count).by(1)
      end

      it "creates seven new Seals." do
        expect {
          post :create, {:contract => valid_attributes, :leaf_id => first.id}, valid_session
        }.to change(Seal, :count).by(7)
      end

      it "updates leaf's last month to Seals' last month." do
        post :create, {:contract => valid_attributes, :leaf_id => first.id}, valid_session
        expect(Leaf.find(1).last_date).to eq(Seal.all.last.month)
      end

      it "redirects to the related leaf." do
        #@leaf = Leaf.find(1)
        post :create, {:contract => valid_attributes, :leaf_id => first.id}, valid_session
        expect(response).to redirect_to(first)
      end
    end

    context "with invalid params" do
      it "fails to create new Contract." do
        expect {
          post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        }.to change(Contract, :count).by(0)
      end

      it "fails to create new Seals." do
        expect {
          post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        }.to change(Seal, :count).by(0)
      end

      it "fails to update leaf's last month to Seals' last month." do
        last_date = first.last_date 
        post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        first.reload
        expect(first.last_date).to eq(last_date)
      end

      it "assigns a newly created but unsaved contract as @contract" do
        post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        expect(assigns(:contract)).to be_a_new(Contract)
      end

      it "re-renders the 'new' template" do
        post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        expect(assigns(:contract)).to be_a_new(Contract)
        expect(response).to render_template("leafs/show")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => new_attributes}, valid_session
        contract.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested contract as @contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => valid_attributes}, valid_session
        expect(assigns(:contract)).to eq(contract)
      end

      it "redirects to the contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => valid_attributes}, valid_session
        expect(response).to redirect_to(contract)
      end
    end

    context "with invalid params" do
      it "assigns the contract as @contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => invalid_attributes}, valid_session
        expect(assigns(:contract)).to eq(contract)
      end

      it "re-renders the 'edit' template" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested contract" do
      contract = Contract.create! valid_attributes
      expect {
        delete :destroy, {:id => contract.to_param}, valid_session
      }.to change(Contract, :count).by(-1)
    end

    it "redirects to the contracts list" do
      contract = Contract.create! valid_attributes
      delete :destroy, {:id => contract.to_param}, valid_session
      expect(response).to redirect_to(contracts_url)
    end
  end

end
