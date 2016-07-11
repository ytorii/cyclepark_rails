require 'rails_helper'

feature "Count Contracts Summary" do

  shared_examples "daily contracts report" do |nickname, password|
    before{
      login(nickname, password)
      visit '/count_contracts_summary'
    }

    it "successes to access to the summary page." do
      expect(page).to have_css('h1', text: '契約台数集計')
    end

    it "displays table header correctly." do
      header =
        %w{ 車種 今月台数 前月比 翌月未更新 今月新規 翌月台数 翌月新規 }
      text_array = all('thead tr th')
      header.each_with_index do |text, i|
        expect(text_array[i]).to have_content(text)
      end
    end

    it "displays count values correctly." do
      title =
        %w{一般 学生 １号地合計 普通バイク 大型バイク バイク合計 ２号地}
      counts = [
        [1, 0, 0, 0, 2, 1],
        [1, 1, 1, 1, 0, 0],
        [2, 1, 1, 1, 2, 1],
        [1, 0, 1, 0, 0, 0],
        [0,-1, 0, 0, 1, 0],
        [1,-1, 1, 0, 1, 0],
        [1, 1, 1, 1, 1, 1]
      ]

      counts_array = all('tbody tr')

      title.each_with_index do |text, i|
        within counts_array[i] do 
          count_text = all('td')
          # Checking if header text is correct.
          expect(count_text[0]).to have_content(title[i])
          # Checking if count values are correct.
          counts[i].each_with_index do |count, j|
            expect(count_text[j+1]).to have_content("#{count.to_s} 台")
          end
        end
      end
    end
  end

  context "with admin staff" do

    let(:count_first_normal_1){ create(:count_first_normal_1) }
    let(:count_first_normal_2){ create(:count_first_normal_2) }
    let(:count_first_normal_3){ create(:count_first_normal_3) }
    let(:count_first_student_1){ create(:count_first_student_1) }
    let(:count_bike_1){ create(:count_bike_1) }
    let(:count_largebike_1){ create(:count_largebike_1) }
    let(:count_second_1){ create(:count_second_1) }
    let(:count_second_2){ create(:count_second_2) }

    context "with valid input" do
      before{
        # staff
        create(:admin)
        create(:normal)
        # leafs(contain customers and contracts)
        count_first_normal_1
        count_first_normal_2
        count_first_normal_3
        count_first_student_1
        count_bike_1
        count_largebike_1
        count_second_1
        count_second_2
      }

      it_behaves_like "daily contracts report", "admin", "12345678"
    end
  end

  context "with normal staff" do
    before{
      login("normal", "abcdefgh")
      visit '/count_contracts_summary'
    }

    it "redirects to login page." do
      expect(page).to have_css('h1', text: 'ログイン')
    end
  end
end
