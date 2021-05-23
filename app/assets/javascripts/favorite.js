$(function() {
  $(document).on('click', '.yellow', function() {
    var word_id = $(this).parent().attr("class");
    $(this).parent().html('<i class="fas fa-star clear"></i>');
    $.ajax({
      url: "/words/unfavorite",
      type: "POST",
      data: {id : word_id}
    });
  });
});

$(function() {
  $(document).on('click', '.clear', function() {
    var word_id = $(this).parent().attr("class");
    $(this).parent().html('<i class="fas fa-star yellow"></i>');
    $.ajax({
      url: "/words/onfavorite",
      type: "POST",
      data: {id : word_id}
    });
  });
});
