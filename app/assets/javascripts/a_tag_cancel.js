$(function (){
  $('.learned_btn_result').on('click', function(){
    $(this).html('<i class="fas fa-check-circle fa-lg" style="color: #8EB8FF" ></i>');
    $(this).css('pointer-events','none');
  });
});

$(function (){
  $('.forgot_btn_result').on('click', function(){
    $(this).html('<i class="fas fa-check-circle fa-lg" style="color: #C0C0C0"></i>');
    $(this).css('pointer-events','none');
  });
});