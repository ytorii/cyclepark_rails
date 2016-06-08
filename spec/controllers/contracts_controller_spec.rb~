require 'rails_helper'

RSpec.describe ContractsController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:first_contract, leaf_id: 1).merge({
      seals_attributes: [{ sealed_flag: true }]
    })
  }

  let(:invalid_attributes) {
    attributes_for(:first_contract, leaf_id: 1, term1: '').merge({
      seals_attributes: [{ sealed_flag: true }]
    })
  }

  let(:new_attributes) {
    attributes_for(:first_contract_add, money1: 3000, contract_date: Date.parse("2016-02-02"), staff_nickname: 'normal').merge({
      seals_attributes: [{ id: contract.seals[0].id, sealed_flag: false }]
    })
  }
  let(:valid_session) { {staff: '1'} }
  let(:normal_session) { {staff: '2'} }

  let(:first) {create(:first)}

  let(:contract) { build(:first_contract) }
  let(:contract_add) { build(:first_contract_add) }

  before{
    first
    create(:admin)
    create(:normal)
  }

  describe "GET #index" do
    it "assigns all contracts as @contracts" do
      contract = Contract.create! valid_attributes
      get :index, { :leaf_id => first.id }, valid_session
      expect(assigns(:contracts)).to eq([contract])
    end
  end

  describe "GET #show" do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :show, {:id => contract.to_param, :leaf_id => first.id}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "GET #edit" do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :edit, {:id => contract.to_param, :leaf_id => first.id}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

#  describe "GET #new", focus: false do
#    it "assigns @leaf from leaf_id in the request params." do
#      get :new, { :leaf_id => first.id }, valid_session
#      expect(assigns(:leaf).id).to eq(first.id)
#    end
#
#    it "assigns leaf_id in the request params to @contract." do
#      get :new, { :leaf_id => first.id }, valid_session
#      expect(assigns(:contract).leaf_id).to eq(first.id)
#    end
#  end

  describe "POST #create" do
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

      it "redirects to the leaf's page." do
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

      it "redirects to the leaf's page." do
        post :create, {:contract => invalid_attributes, :leaf_id => first.id}, valid_session
        expect(assigns(:contract)).to be_a_new(Contract)
        expect(response).to redirect_to(first)
      end
    end
  end

  describe "PUT #update" do
    let(:contract) { create(:first_contract_add, leaf_id: first.id) }

    before{ contract }

    context "with valid params" do
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

      it "redirects to the leaf's page." do
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

      it "redirects to the leaf's page." do
        put :update, {:id => contract.to_param, :leaf_id => contract.leaf_id, :contract => valid_attributes}, valid_session
        expect(response).to redirect_to(leaf_path(contract.leaf_id))
      end
    end
  end

  describe "DELETE #destroy" do
    let(:contract_add) { create(:first_contract_add, leaf_id: first.id) }
    let(:contract) { create(:first_contract, leaf_id: first.id) }

    before{
      contract_add
      contract
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

    it "redirects to the leaf's page." do
      delete :destroy, {:id => contract.to_param, :leaf_id => contract.leaf_id}, valid_session
      expect(response).to redirect_to(leaf_path(first.id))
    end
  end
end
