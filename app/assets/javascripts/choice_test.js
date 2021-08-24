$(function() {
  $('.btn-animation-02').on('click', function(){
    $(this).parent().next().find(".test_btn").fadeToggle('fast');
    var a = $(this).parent().next().find(".test_btn");
    var b = $('.select_box').find('.test_btn').not(a);
    b.each(function(value, element) {
      if ($(element).css('display') == 'inline') {
        $(element).fadeToggle('fast');
      }
    })
  });
});

$(function() {
  $('.news i').on('click', function(){
    $('.news p').toggle();
  });
});



