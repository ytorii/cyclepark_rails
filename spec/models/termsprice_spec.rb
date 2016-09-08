require 'rails_helper'

RSpec.describe Termsprice, type: :model do
  let(:termsprice){ Termsprice.new(leaf_id: leaf_id, term: term) }

  describe '.term' do
    let(:leaf_id){ 1 }
    let(:term){ 1 }
    before{ create(:first) }

    context 'with valid values' do
      [1, 6, 12].each do |value|
        it "#{value} is valid." do
          termsprice.term = value
          expect(termsprice).to be_valid
        end
      end
    end

    context 'with invalid values' do
      [0, 13, 3.5, 'a', 'あ'].each do |value|
        it "#{value} is invalid." do
          termsprice.term = value
          expect(termsprice).not_to be_valid
          expect(termsprice.errors[:term]).to be_present
        end
      end
    end
  end

  describe '.leaf_exists?' do
    let(:term){ 1 }
    before{ create(:first) }

    context 'with existing leaf' do
      let(:leaf_id){ 1 }
      it 'is valid.' do
        expect(termsprice).to be_valid
      end
    end

    context 'with NOT existing leaf' do
      let(:leaf_id){ 2 }
      it 'is invalid.' do
        expect(termsprice).not_to be_valid
        expect(termsprice.errors[:leaf_id]).to be_present
      end
    end
  end

  describe '.calc_price' do
    let(:leaf_id){ 1 }
    subject { termsprice.calc_price }

    context 'with first customer' do
      context 'with normal' do
        let(:normal_prices){[3500, 7000, 9500, 13_000, 16_500, 18_000]}
        before{ create(:first) }

        [*1..6].each do |i|
          context "with #{i} months" do
            let(:term){ i }
            it { is_expected.to eq(normal_prices[i-1]) }
          end
        end
      end

      context 'with student' do
        let(:student_prices){[3000, 6000, 8500, 11_500, 14_500, 15_800]}
        before{ create(:first, student_flag: true) }

        [*1..6].each do |i|
          context "with #{i} months" do
            let(:term){ i }
            it { is_expected.to eq(student_prices[i-1]) }
          end
        end
      end
    end

    context 'with bike customer' do

      context 'with normal bike' do
        before{ create(:first, vhiecle_type: 2, largebike_flag: false) }
        [*1..12].each do |i|
          context "with #{i} months" do
            let(:term){ i }
            it { is_expected.to eq( i * 5500 ) }
          end
        end
      end

      context 'with large bike' do
        before{ create(:first, vhiecle_type: 2, largebike_flag: true) }

        [*1..12].each do |i|
          context "with #{i} months" do
            let(:term){ i }
            it { is_expected.to eq( i * 6500 ) }
          end
        end
      end
    end

    context 'with second customer' do
      before{ create(:first, vhiecle_type: 3) }

      [*1..12].each do |i|
        context "with #{i} months" do
          let(:term){ i }
          it { is_expected.to eq( i * 2500 ) }
        end
      end
    end
  end
end
