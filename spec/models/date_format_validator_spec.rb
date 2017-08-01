require 'rails_helper'

RSpec.describe DateFormatValidator do
  let(:date){ '2016/06/11' }
  subject{ DateFormatValidator.new(date) }

  describe 'attribute' do
    it { is_expected.to respond_to :date }
    it { is_expected.to respond_to :date= }
  end

  describe 'validation' do
    describe '#date' do
      it { is_expected.
           to allow_value('2000/01/01', '2099/12/31', nil).for(:date) }
      it { is_expected.
           not_to allow_value('1999/12/31', '2100/01/01').for(:date) }
      it { is_expected.
           not_to allow_value(0, true, 'a', 'あ').for(:date) }
    end
  end
end
