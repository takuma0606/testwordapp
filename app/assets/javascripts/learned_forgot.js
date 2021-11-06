$(function() {
  $(document).on('click', '.learned_btn_result', function() {
    const word_id = $(this).parent().attr("class");
    $(this).parent().html('<i class="fas fa-check-circle fa-lg forgot_btn_result" style="color: #8EB8FF"></i>');
    $.ajax({
      url: "/words/learned",
      type: "POST",
      data: {id : word_id}
    });
  });
});

$(function() {
  $(document).on('click', '.forgot_btn_result', function() {
    const word_id = $(this).parent().attr("class");
    $(this).parent().html('<i class="fas fa-check-circle fa-lg learned_btn_result" style="color: #C0C0C0"></i>');
    $.ajax({
      url: "/words/forgot",
      type: "POST",
      data: {id : word_id}
    });
  });
});

$(function(){
  $('.learned_btn').on('click', function(){
    const word_id = $(this).parent().attr("class");
    $(this).parents("tr").hide();
    $.ajax({
      url: "/words/learned",
      type: "POST",
      data: {id : word_id}
    });
  });
});

$(function(){
  $('.forgot_btn').on('click', function(){
    const word_id = $(this).parent().attr("class");
    $(this).parents("tr").hide();
    $.ajax({
      url: "/words/forgot",
      type: "POST",
      data: {id : word_id}
    });
  });
});
