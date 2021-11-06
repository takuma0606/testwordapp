$(function() {
  $('.btn-animation-02').on('click', function(){
    $(this).parent().next().find(".test_btn").fadeToggle('fast');
    const a = $(this).parent().next().find(".test_btn");
    const b = $('.select_box').find('.test_btn').not(a);
    b.each(function(value, element) {
      if ($(element).css('display') == 'inline') {
        $(element).fadeToggle('fast');
      }
    })
  });
});



