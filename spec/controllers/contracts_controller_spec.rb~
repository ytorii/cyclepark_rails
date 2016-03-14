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
      staff_nickname: 'admin',
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

  let(:valid_session) { {staff: '1'} }
  let(:normal_session) { {staff: '2'} }
  let(:first) {create(:first)}

  before{
    create(:admin)
    create(:normal)
  }

  describe "GET #index", focus: false do
    it "assigns all contracts as @contracts" do
      contract = Contract.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:contracts)).to eq([contract])
    end
  end

  describe "GET #show", focus: false do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :show, {:id => contract.to_param}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "GET #edit", focus: false do
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

  describe "POST #create", focus: false do
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
        expect(Leaf.find(first.id).last_date).to eq(Seal.all.last.month)
      end

      it "redirects to the related leaf." do
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

  describe "PUT #update", focus: false do
    let(:contract) { build(:first_contract_add) }

    before{
      contract.leaf = first
      contract.seals.first.sealed_flag = true
      contract.save!
    }

    context "with valid params" do
      let(:new_attributes) {
        {
          id: contract.id,
          leaf_id: first.id,
          contract_date: "2016-02-02",
          money1: 3000,
          staff_nickname: "normal",
          start_month: "2016-02-01",
          term1: 1,
          term2: '',
          money2: '',
          new_flag: 'true',
          skip_flag: false,
          seals_attributes: [{
            id: contract.seals[0].id,
            month: '2016-02-01',
            sealed_date: '2016-01-01',
            sealed_flag: false,
            staff_nickname: 'admin'
          }]
        }
      }

      it "updates the requested contract" do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => new_attributes}, valid_session
        contract.reload
        expect(contract.money1).to eq(3000)
        expect(contract.staff_nickname).to eq("normal")
        expect(contract.contract_date).to eq(Date.parse("2016-02-02"))
      end

      it "updates sealed_flag and staf_nickname to nil with false sealed_flag." do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => new_attributes}, valid_session
        contract.reload
        expect(contract.seals.first.sealed_flag).to eq(false)
        expect(contract.seals.first.sealed_date).to eq(nil)
        expect(contract.seals.first.staff_nickname).to eq(nil)
      end

      it "assigns the requested contract as @contract" do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => new_attributes}, valid_session
        contract.reload
        expect(assigns(:contract)).to eq(contract)
      end

      it "redirects to the leaf" do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => new_attributes}, valid_session
        contract.reload
        expect(response).to redirect_to(leaf_path(contract.leaf_id))
      end
    end

    context "with changed terms" do
      it "assigns the requested contract as @contract" do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => valid_attributes}, valid_session
        contract.reload
        expect(assigns(:contract)).to eq(contract)
      end

      it "re-renders the 'new' template" do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => valid_attributes}, valid_session
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy", focus: true do
    let(:contract) { build(:first_contract) }
    let(:contract_add) { build(:first_contract_add) }

    before{
      contract_add.leaf = first
      contract_add.seals.first.sealed_flag = true
      contract_add.save!

      contract.leaf = first
      contract.seals.first.sealed_flag = true
      contract.save!
    }

    it "destroys the requested contract" do
      expect {
        delete :destroy, {:id => contract.to_param, :leaf_id => contract.leaf_id}, valid_session
      }.to change(Contract, :count).by(-1)
    end

    it "destroys seals related to the destroyed contract." do
      expect {
        delete :destroy, {:id => contract.to_param, :leaf_id => contract.leaf_id}, valid_session
      }.to change(Seal, :count).by(-7)
    end

    it "changes leaf's last_date to the last seal's month after deleted." do
        delete :destroy, {:id => contract.to_param, :leaf_id => contract.leaf_id}, valid_session
        first.reload
        expect(first.last_date).to eq(contract_add.seals.last.month)
    end

    it "rejects to destroy contract unless it is the last contract." do
      expect {
        delete :destroy, {:id => contract_add.to_param, :leaf_id => contract_add.leaf_id}, valid_session
      }.to change(Contract, :count).by(0)
    end

    it "redirects to the leaf" do
      delete :destroy, {:id => contract.to_param, :leaf_id => contract.leaf_id}, valid_session
      expect(response).to redirect_to(leaf_path(first.id))
    end
  end

end
