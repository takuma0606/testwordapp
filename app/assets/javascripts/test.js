$(function() {
    $('.quiz_area').on('click', '.word_mean', function(){
        $('.quiz_area').find('.quiz_area_bg').show();
        const judge = $(this).text();
        const word_id = $('.favorite-button div').attr("class");
        const parent = this;
        
        //ajax通信でword#judgeにユーザーが選択した回答と出題単語のidを送信
        $.ajax({
          url: "/words/judge",
          type: "POST",
          data: {answer : judge, question_id : word_id},
          dataType: 'json'
        })
        .done(function(data) {
          //選択した選択肢の背景を灰色に、正解の選択肢の背景を赤色にする
          $('a.word_mean:contains('+data.ans+')').css("background-color","#FF9999");
          $(parent).css("background-color","#CCC");

          //word#judgeから送られてきた真偽値を基に〇✕を表示、音声を出力
          if (data.test) {
            $('.quiz_area').find('.quiz_area_icon').addClass('true');
            document.querySelector("#correct").play();
          }else{
            $('.quiz_area').find('.quiz_area_icon').addClass('false');
            document.querySelector("#wrong").play();
          }

          setTimeout(function() {
            $('.quiz_area').find('.quiz_area_icon').removeClass('true false');
          },1000);

          //次の問題に進むためのボタンを出現させる
          if (gon.number < 5 && gon.learned) {
            $('div.next').html('<a href="/words/learned_test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else if (gon.number < 5 && gon.favorite) {
            $('div.next').html('<a href="/words/favorite_test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else if (gon.number < 5 && gon.wrong) {
            $('div.next').html('<a href="/words/wrong_test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else if (gon.number < 5){
            $('div.next').html('<a href="/words/test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else{
            $('div.next').html('<a href="/words/result" class="next_test"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }
        });
    });
});
