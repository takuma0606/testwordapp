$(function() {
  $('.plus').on('click', function(){
    if ($(this).hasClass('plus--active')){
      $(this).removeClass('plus--active');
    } else {
      $(this).addClass('plus--active');
      $('.plus').not(this).removeClass('plus--active');
    }
  });
});