$(function() {
  $('#all').on('click', function() {
    $("input[name='deletes[]']").prop('checked', $(this).prop("checked"));
  });
  $("input[name='deletes[]']").on('click', function() {
    if ($('#boxes :checked').length == $('#boxes :input').length) {
      $('#all').prop('checked', true);
    } else {
      $('#all').prop('checked', false);
    }
  });
});
