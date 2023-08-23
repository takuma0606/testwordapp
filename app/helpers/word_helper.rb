module WordHelper
    def result_pop(maru)
        if maru == 5
            "excellent"
        elsif maru == 3 || maru == 4
            "good"
        else
            "bad"
        end
    end

    def result_number 
        maru_number = 0
        @results.each do |result|
            if result.answer == result.solution 
                maru_number += 1
            end
        end
        return maru_number
    end

    #もう一度テストをしたとき、テスト中に別の画面に遷移した時にテストに使用するモデルのレコードを削除するアクション
    def model_reset
      List.where(user_id: @current_user.id).destroy_all 
      Result.where(user_id: @current_user.id).destroy_all 
      Partofspeech.where(user_id: @current_user.id).destroy_all 
    end
end
