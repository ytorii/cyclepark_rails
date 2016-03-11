require 'rails_helper'

RSpec.describe LeafsController, type: :controller do

  let(:valid_attributes) {
    {
      number: 1,
      vhiecle_type: 2,
      student_flag: false,
      largebike_flag: false,
      valid_flag: true,
      start_date: "2016-02-01",
      last_date: "2016-05-31",
      customer_attributes: {
        first_name: "自転車",
        last_name: "太郎",
        first_read: "ジテンシャ",
        last_read: "タロウ",
        sex: true,
        address: "寝屋川市八坂町１－１",
        phone_number: "072-820-0158",
        cell_number: "090-4563-6103",
        receipt: "㈱夕日システムズ",
        comment: "一時利用より"
      }
    }
  }

  let(:invalid_attributes) {
    {
      number: "",
      vhiecle_type: 2,
      student_flag: false,
      largebike_flag: false,
      valid_flag: true,
      start_date: "2016-02-01",
      last_date: "2016-05-31",
      customer_attributes: {
        first_name: "自転車",
        last_name: "太郎",
        first_read: "ジテンシャ",
        last_read: "タロウ",
        sex: true,
        address: "寝屋川市八坂町１－１",
        phone_number: "072-820-0158",
        cell_number: "090-4563-6103",
        receipt: "㈱夕日システムズ",
        comment: "一時利用より"
      }
    }
  }

  let(:valid_contract) {
    {
      contract:
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
  }

  let(:invalid_contract) {
    {
      contract:
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
  }

  let(:valid_session) { {staff: '1'} }

  before{ create(:admin) }

  describe "GET #index" do
    it "assigns all leafs as @leafs" do
      leaf = Leaf.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:leafs)).to eq([leaf])
    end
  end

  describe "GET #show" do
    it "assigns the requested leaf as @leaf" do
      leaf = Leaf.create! valid_attributes
      get :show, {:id => leaf.to_param}, valid_session
      expect(assigns(:leaf)).to eq(leaf)
    end
  end

  describe "GET #new" do
    it "assigns a new leaf as @leaf" do
      get :new, {}, valid_session
      expect(assigns(:leaf)).to be_a_new(Leaf)
    end
  end

  describe "GET #edit" do
    it "assigns the requested leaf as @leaf" do
      leaf = Leaf.create! valid_attributes
      get :edit, {:id => leaf.to_param}, valid_session
      expect(assigns(:leaf)).to eq(leaf)
    end
  end

  describe "POST #create", :focus => false do
    context "with valid params" do
      it "creates a new Leaf" do
        expect {
          post :create, {:leaf => valid_attributes}, valid_session
        }.to change(Leaf, :count).by(1).and change(Customer, :count).by(1)
      end

      it "assigns a newly created leaf as @leaf" do
        post :create, {:leaf => valid_attributes}, valid_session
        expect(assigns(:leaf)).to be_a(Leaf)
        expect(assigns(:leaf)).to be_persisted
      end

      it "redirects to the created leaf's contract page." do
        post :create, {:leaf => valid_attributes}, valid_session
        expect(response).to redirect_to(new_leaf_contract_path(1))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved leaf as @leaf" do
        post :create, {:leaf => invalid_attributes}, valid_session
        expect(assigns(:leaf)).to be_a_new(Leaf)
      end

      it "re-renders the 'new' template" do
        post :create, {:leaf => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update for leaf and customer", :focus => true do
    let(:leaf){Leaf.create! valid_attributes}

    context "with valid params" do
      let(:new_attributes) {
        {
          number: 1,
          vhiecle_type: 2,
          student_flag: true,
          largebike_flag: false,
          valid_flag: true,
          start_date: "2016-02-01",
          last_date: "2016-05-31",
          customer_attributes: {
            first_name: "自転車",
            last_name: "太郎",
            first_read: "ジテンシャ",
            last_read: "タロウ",
            sex: true,
            address: "寝屋川市八坂町１－１",
            phone_number: "072-820-0158",
            cell_number: "090-4563-6103",
            receipt: "㈱夕日システムズ",
            comment: "復活"
          }
        }
      }

      it "updates the requested leaf." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, valid_session
        leaf.reload
          expect(leaf.student_flag).to eq(true)
          expect(leaf.customer.comment).to eq("復活")
      end

      it "assigns the requested leaf as @leaf." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, valid_session
        expect(assigns(:leaf)).to eq(leaf)
      end

      it "redirects to the leaf's page." do
        put :update, {:id => leaf.to_param, :leaf => new_attributes}, valid_session
        expect(response).to redirect_to(leaf_path(leaf.to_param))
      end
    end

    context "with invalid params" do
      it "assigns the leaf as @leaf" do
        put :update, {:id => leaf.to_param, :leaf => invalid_attributes}, valid_session
        expect(assigns(:leaf)).to eq(leaf)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => leaf.to_param, :leaf => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PUT #update for contract", :focus => true do
    let(:leaf){Leaf.create! valid_attributes}

    context "with valid params" do
      it "creates one new Contract." do
        expect {
          put :update, {:id => leaf.to_param, :leaf => valid_contract}, valid_session
        }.to change(Contract, :count).by(1)
      end

      it "creates seven new Seals." do
        expect {
          put :update, {:id => leaf.to_param, :leaf => valid_contract}, valid_session
        }.to change(Seal, :count).by(7)
      end

      it "updates leaf's last month to Seals' last month." do
        put :update, {:id => leaf.to_param, :leaf => valid_contract}, valid_session
        leaf.reload
        expect(leaf.last_date).to eq(leaf.contracts.last.seals.last.month)
      end

      it "redirects to the created contract" do
        put :update, {:id => leaf.to_param, :leaf => valid_contract}, valid_session
        expect(response).to redirect_to(leaf)
      end
    end

    context "with invalid params" do
      it "fails to create new Contract." do
        expect {
          put :update, {:id => leaf.to_param, :leaf => invalid_contract}, valid_session
        }.to change(Contract, :count).by(0)
      end

      it "fails to create new Seals." do
        expect {
          put :update, {:id => leaf.to_param, :leaf => invalid_contract}, valid_session
        }.to change(Seal, :count).by(0)
      end

      it "fails to update leaf's last month to Seals' last month." do
        last_date = leaf.last_date 
        put :update, {:id => leaf.to_param, :leaf => invalid_contract}, valid_session
        leaf.reload
        expect(leaf.last_date).to eq(last_date)
      end

      it "assigns a newly built but unsaved contract as @contract" do
        put :update, {:id => leaf.to_param, :leaf => invalid_contract}, valid_session
        expect(assigns(:leaf)).to eq(leaf)
      end

      it "re-renders the 'show' template" do
        put :update, {:id => leaf.to_param, :leaf => invalid_contract}, valid_session
        expect(response).to render_template("show")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested leaf" do
      leaf = Leaf.create! valid_attributes
      expect {
        delete :destroy, {:id => leaf.to_param}, valid_session
      }.to change(Leaf, :count).by(-1)
    end

    it "redirects to the leafs list" do
      leaf = Leaf.create! valid_attributes
      delete :destroy, {:id => leaf.to_param}, valid_session
      expect(response).to redirect_to(leafs_url)
    end
  end

end
