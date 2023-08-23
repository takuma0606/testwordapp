class WordsController < ApplicationController
  before_action:need_login

  
  def new 
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)
    if @word.save 
      redirect_to new_word_path(part_of_speech: word_params[:part_of_speech])
    else
      render :action => "new"
    end
  end


  def index
    if params[:search].present?
    # 検索フォームからアクセスした時の処理
      search = Word.search(@current_user.id,params[:search])
      if params[:learned_and_forgot] 
        if (params[:favorited] && params[:learned]) || params[:favorited]
          @words = search.where(favorite: true).with_deleted.order(deleted_at: :desc)
        else
          @words = search.with_deleted.order(deleted_at: :desc)
        end
      elsif params[:learned] && params[:favorited]
        @words = search.where(favorite: true).only_deleted.order(deleted_at: :desc)
      elsif params[:learned]
        @words = search.only_deleted.order(deleted_at: :desc)
      elsif params[:favorited]
        @words = search.where(favorite: true)
      else
        @words = search.order(created_at: :desc)
      end
    else
    # 検索フォーム以外からアクセスした時の処理
      nonsearch = Word.nonsearch(@current_user.id)
      if params[:learned_and_forgot] 
        if (params[:favorited] && params[:learned]) || params[:favorited]
          @words = nonsearch.where(favorite: true).with_deleted.order(deleted_at: :desc)
        else
          @words = nonsearch.with_deleted.order(deleted_at: :desc)
        end
      elsif params[:learned] && params[:favorited]
        @words = nonsearch.where(favorite: true).only_deleted.order(deleted_at: :desc)
      elsif params[:learned]
        @words = nonsearch.only_deleted.order(deleted_at: :desc)
      elsif params[:favorited]
        @words = nonsearch.where(favorite: true)
      else
        @words = nonsearch.order(created_at: :desc)
      end
    end
  end

  def choice_test
    @part_of_speeches = ["動詞","名詞","形容詞","副詞","熟語"]
  end

  
  # 覚えたボタン
  def learned
    word = Word.find(params[:id])
    word.update(wrong_number: 0, count: 0)
    word.destroy #仮削除する
  end

  # 忘れたボタン
  def forgot
    word = Word.only_deleted.find(params[:id])
    word.restore #仮削除されたレコードを復元するメソッド
  end

  
  #index画面でチェックボックスにチェックした単語を本当に削除するアクション
  def destroy_all
    if params[:deletes]
      params[:deletes].each do |data|
        Word.with_deleted.find(data).really_destroy! #.really_destroy! <- 本当に削除するメソッド
      end
      redirect_to request.referer
    else 
      redirect_to request.referer
    end
  end

  #index画面で各リストの削除ボタンを押下したときに該当単語を本当に削除するアクション
  def destroy
    Word.with_deleted.find(params[:id]).really_destroy!
    redirect_to words_path
  end


  def update
    @word = Word.with_deleted.find(params[:id])
    @word.update(word_edit_params)
    respond_to do |format|
      format.html { redirect_to @word}
      format.json { render json: @word }
    end
  end

  #テスト画面で示される選択肢を作成するアクション
  def choices(name)
    #Wordテーブルからchoices2の返り値の品詞のデータを取ってきて、ランダムなデータを4つ取得する。そして取得したデータを単語の意味の配列にする
    @words_meaning = Word.with_deleted.where(user_id: @current_user.id, part_of_speech: name).order(Arel.sql("RANDOM()")).limit(4).map{|word| word.meaning}

    #@words_meaningリストに@random.meaningのデータが含まれていなかったら配列のランダムな位置の要素@random.meaningと入れ替える
    @words_meaning[rand(4)] = @random.meaning if @words_meaning.exclude?(@random.meaning)

    #上記のコードで取得したデータを元にListモデル(出題記録をつけるモデル)のインスタンスを作る
    List.create(word: @random.word, meaning: @words_meaning, user_id: @current_user.id)
    gon.number = @number = List.where(user_id: @current_user.id).count
  end

  #テスト選択画面で選択した品詞を出力するアクション
  def choices2
    #テスト結果画面でもう一度ボタンが押されたときはテストに関係するモデルのレコードを削除する
    model_reset if params[:mark]
    #最初の問題のときのみPartofspeechモデル(ユーザーがテスト選択画面で選択した品詞、該当テストへのパスを保存するモデル)を作成
    Partofspeech.create(user_id: @current_user.id, name: params[:name], path: params[:path]) if List.where(user_id: @current_user.id).count == 0
    #品詞名を変数nameに代入
    name = Partofspeech.find_by(user_id: @current_user.id).name
    #出題された単語の配列であるlistword配列を作成する
    listword = List.where(user_id: @current_user.id).pluck(:word)
    return [name, listword]
  end 

  #覚えていない単語のテスト画面のアクション
  def test
    #テスト画面のURLが直接入力されたらホーム画面に遷移する
    unless request.referer
      redirect_to "/"
    else
      #テスト画面で出題される単語を決定する。ユーザーがテスト選択画面で選択した品詞の単語であり、既に出題された単語出ない単語である。さらに出題回数の少ない単語が選ばれる。
      @random = Word.search(@current_user.id,choices2[0]).where.not(word: choices2[1]).order(:count).first
      #該当の単語数が5つ未満の場合はテスト選択画面に戻る
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "覚えたい単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました" }
      else
        #出題回数を1増やす
        @random.update(count: @random.count + 1)
        #選択肢の単語の意味はchoices、choices2アクションで作成する
        choices(choices2[0])
      end
    end
  end

  #覚えた単語のテスト画面のアクション
  def learned_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.only_deleted.where(user_id: @current_user.id, part_of_speech: choices2[0]).where.not(word: choices2[1]).order(:forgot_count).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "覚えた単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました" }
      else
        @random.update(forgot_count: @random.forgot_count + 1)
        choices(choices2[0])
        gon.learned = true
        render 'test'
      end
    end
  end

  #お気に入り登録した単語のテスト画面のアクション
  def favorite_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.search(@current_user.id,choices2[0]).where(favorite: true).where.not(word: choices2[1]).order(:favorite_count).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "お気に入りにした単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました" }
      else
        @random.update(favorite_count: @random.favorite_count + 1)
        choices(choices2[0])
        gon.favorite = true
        render 'test'
      end
    end
  end

  #間違えやすい単語のテスト画面のアクション
  def wrong_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.where(user_id: @current_user.id, part_of_speech: choices2[0], wrong_number: 2..Float::INFINITY).where.not(word: choices2[1]).order(wrong_number: "DESC").first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "間違えやすい単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました" }
      else
        choices(choices2[0])
        gon.wrong = true
        render 'test'
      end
    end
  end

  #テスト結果画面のアクション
  def result
    unless request.referer 
      redirect_to "/"
    else
      @results = Result.where(user_id: @current_user.id)
      @obj = Partofspeech.find_by(user_id: @current_user.id)
    end
  end

  #テストの正誤を判定するアクション
  def judge
    #test.jsのajaxで送られたデータを使い問題の単語のレコードを検索
    question = Word.with_deleted.find(params[:question_id])
    q_meaning = question.meaning
    q_id = question.id
    #ユーザーが答えた解答が合っているか確認
    if q_meaning == params[:answer]
      test = {'test' => true}
      if Word.exists?(id: q_id)
        #合っていたら間違えた回数を1減らす
        question.update(wrong_number: question.wrong_number - 1)
      end
    else
      test = {'test' => false}
      if Word.exists?(id: q_id)
        #間違っていたら間違えた回数を1増やす
        question.update(wrong_number: question.wrong_number + 1)
      end
    end
    #結果画面で結果を出力するためのレコードを作成
    Result.create(answer: params[:answer], solution: q_meaning, user_id: @current_user.id, q_word: question.word, q_id: q_id)
    test['ans'] = q_meaning
    render :json => test
  end

  # お気に入り解除
  def unfavorite
    word = Word.with_deleted.find(params[:id])
    word.update(favorite: false, favorite_count: 0)
  end

  # お気に入り登録
  def onfavorite
    word = Word.with_deleted.find(params[:id])
    word.update(favorite: true)
  end



  private
  def word_params
    params.require(:word).permit(:word,:meaning,:user_id,:part_of_speech)
  end

  def word_edit_params
    params.require(:word).permit(:word,:meaning)
  end

end
