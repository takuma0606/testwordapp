$(function() {
    $('.quiz_area').on('click', '.word_mean', function(){
        $('.quiz_area').find('.quiz_area_bg').show();
        var judge = $(this).text();
        var question = $('p.q_word').text();
        const parent = this;

        $.ajax({
          url: "/words/judge",
          type: "POST",
          data: {answer : judge, question : question},
          dataType: 'json'
        })
        .done(function(data) {
          $('a.word_mean:contains('+data.ans+')').css("background-color","#FF9999");
          $(parent).css("background-color","#CCC");

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

          if (gon.number < 5 && gon.learned) {
            $('div.next').html('<a href="/words/learned_test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else if (gon.number < 5 && gon.favorite) {
            $('div.next').html('<a href="/words/favorite_test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else if (gon.number < 5){
            $('div.next').html('<a href="/words/test" class="next_test" onclick="$(this).click(function(e){ return false });"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }else{
            $('div.next').html('<a href="/words/result" class="next_test"><i class="fas fa-chevron-circle-right fa-lg"></i></a>');
          }
        });
    });
});
