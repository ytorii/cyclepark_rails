require 'rails_helper'

feature "Daily Contracts Report" do

  let(:daily_first_nrm_1){ create(:daily_first_nrm_1) }
  let(:daily_first_std_1){ create(:daily_first_std_1) }
  let(:daily_bike_1){ create(:daily_bike_1) }
  let(:daily_large_bike_1){ create(:daily_large_bike_1) }
  let(:daily_second_1){ create(:daily_second_1) }
  let(:daily_first_nrm_2){ create(:daily_first_nrm_2) }
  let(:today){ Date.today.strftime('%Y年%-m月%-d日').concat('の契約一覧') }

  before :all do
    # leafs(contain customers and contracts)
    create(:daily_first_nrm_1) 
    create(:daily_first_std_1) 
    create(:daily_bike_1) 
    create(:daily_large_bike_1) 
    create(:daily_second_1) 
    create(:daily_first_nrm_2) 
  end

  shared_examples 'daily contracts report' do |nickname, password|
    before{
      login(nickname, password)
      visit '/daily_contracts_report'
    }

    context 'from other page' do
      it 'successes to access to the report page.' do
        expect(page).to have_css('h1', text: '日毎契約一覧')
        expect(page).to have_selector('.lead', text: today)
        expect(page).to have_content('合計  0件 \0')
      end
    end

    context 'from same page' do
      context 'with empty date input' do
        it 'successes to access to the report page.' do
          click_button '指定した日付を表示'
          expect(page).to have_css('h1', text: '日毎契約一覧')
          expect(page).to have_selector('.lead', text: today)
          expect(page).to have_content('合計  0件 \0')
        end
      end

      context 'with selected date input' do
        it 'successes to access to the report page.' do
          within('form') do
            fill_in_val 'contracts_date', with: Date.parse('2016/01/16')
          end
          click_button '指定した日付を表示'
          expect(page).to have_css('h1', text: '日毎契約一覧')
          expect(page).to have_selector('.lead',
                                        text: '2016年1月16日の契約一覧')
          expect(page).to have_content('合計  5件 \48,300')
          expect(page).to have_content(
            '１号地  2件 \28,500, バイク  2件 \14,800, ２号地  1件 \5,000'
          )
        end
      end

      context 'with invalid contracts date' do
        before{
          within('form') do
            fill_in_val 'contracts_date', with: Date.parse('1900/01/01')
          end
          click_button '指定した日付を表示'
        }

        it 'redirects to menu page.' do
          expect(page).to have_css('h1', text: 'メインメニュー')
        end

        it 'displays error message.' do
          expect(find('#system_messages')).to have_content('は不正な値です')
        end
      end
    end
  end

  describe 'Admin staff' do
    it_behaves_like 'daily contracts report', 'admin', '12345678'
  end

  describe 'Normal staff' do
    it_behaves_like 'daily contracts report', 'normal', 'abcdefgh'
  end
end
