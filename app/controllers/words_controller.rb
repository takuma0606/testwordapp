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
      if params[:learned_and_forgot] && params[:favorited] && params[:learned]
        @words = search.where(favorite: true).with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot] && params[:favorited]
        @words = search.where(favorite: true).with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot] && params[:learned]
        @words = search.with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot]
        @words = search.with_deleted.order(deleted_at: :desc)
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
      if params[:learned_and_forgot] && params[:favorited] && params[:learned]
        @words = nonsearch.where(favorite: true).with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot] && params[:favorited]
        @words = nonsearch.where(favorite: true).with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot] && params[:learned]
        @words = nonsearch.with_deleted.order(deleted_at: :desc)
      elsif params[:learned_and_forgot]
        @words = nonsearch.with_deleted.order(deleted_at: :desc)
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
    word.update(wrong_number: 0)
    word.destroy
  end

  # 忘れたボタン
  def forgot
    Word.only_deleted.find(params[:id]).restore
  end

  

  def destroy_all
    if params[:deletes] != nil
      params[:deletes].each do |data|
        Word.with_deleted.find(data).really_destroy!
      end
      redirect_to request.referer
    end
  end

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

  def choices(name)
    #Wordテーブルからログインユーザーのidのデータを取ってきて、ランダムなデータを4つ取得する。そして取得したデータを単語の意味の配列にする
    @words_meaning = Word.with_deleted.where(user_id: @current_user.id, part_of_speech: name).order(Arel.sql("RANDOM()")).limit(4).map{|word| word.meaning}

    #@words_meaningリストに@random.meaningのデータが含まれていなかったら配列のランダムな位置の要素@random.meaningと入れ替える
    @words_meaning[rand(4)] = @random.meaning if @words_meaning.exclude?(@random.meaning)

    #上記のコードで取得したデータを元にListモデルのインスタンスを作る
    List.create(word: @random.word, meaning: @words_meaning, user_id: @current_user.id)
    gon.number = @number = List.where(user_id: @current_user.id).count
  end

  def choices2
    model_reset if params[:mark]
    Partofspeech.create(user_id: @current_user.id, name: params[:name], path: params[:path]) if List.where(user_id: @current_user.id).count == 0
    name = Partofspeech.find_by(user_id: @current_user.id).name
    listword = List.where(user_id: @current_user.id).pluck(:word)
    return [name, listword]
  end 


  def test
    unless request.referer
      redirect_to "/"
    else

      @random = Word.search(@current_user.id,choices2[0]).where.not(word: choices2[1]).order(:count).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "覚えたい単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました。再びテストをするには単語を登録してください" }
      else
        @random.update(count: @random.count + 1)
        choices(choices2[0])
      end
    end
  end

  def learned_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.only_deleted.where(user_id: @current_user.id, part_of_speech: choices2[0]).where.not(word: choices2[1]).order(Arel.sql("RANDOM()")).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "覚えた単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました。" }
      else
        choices(choices2[0])
        gon.learned = true
        render 'test'
      end
    end
  end

  def favorite_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.search(@current_user.id,choices2[0]).where(favorite: true).where.not(word: choices2[1]).order(Arel.sql("RANDOM()")).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "お気に入りにした単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました。再びテストをするにはお気に入り登録をしてください" }
      else
        choices(choices2[0])
        gon.favorite = true
        render 'test'
      end
    end
  end

  def wrong_test
    unless request.referer
      redirect_to "/"
    else
      @random = Word.where(user_id: @current_user.id, part_of_speech: choices2[0], wrong_number: 2..Float::INFINITY).where.not(word: choices2[1]).order(Arel.sql("RANDOM()")).first
      unless @random      
        redirect_to choice_test_words_path, flash: {error: "間違えやすい単語(品詞：#{choices2[0]})の数が5つ未満になったためテストを中断しました。" }
      else
        choices(choices2[0])
        gon.wrong = true
        render 'test'
      end
    end
  end


  def result
    unless request.referer 
      redirect_to "/"
    else
      @results = Result.where(user_id: @current_user.id)
      @obj = Partofspeech.find_by(user_id: @current_user.id)
    end
  end

  # 以下ajaxを用いた
  def judge
    question = Word.with_deleted.find_by(user_id: @current_user.id, word: params[:question])
    q_meaning = question.meaning
    q_id = question.id
    if q_meaning == params[:answer]
      test = {'test' => true}
      if Word.exists?(id: q_id)
        question.update(wrong_number: question.wrong_number - 1)
      end
    else
      test = {'test' => false}
      if Word.exists?(id: q_id)
        question.update(wrong_number: question.wrong_number + 1)
      end
    end
    Result.create(answer: params[:answer], solution: q_meaning, user_id: @current_user.id, q_word: params[:question], q_id: q_id)
    test['ans'] = q_meaning
    render :json => test
  end

  # お気に入り解除
  def unfavorite
    word = Word.with_deleted.find(params[:id])
    word.update(favorite: false)
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
