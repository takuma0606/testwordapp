$(function(){
	$('#narrow-down').on("click",function(){
		var re = new RegExp($('#search-field').val());
		$('.index_table tbody tr').each(function(){
			var txt = $(this).find("td:eq(6)").html();
      var txt2 = $(this).find("td:eq(4)").html();
			if(txt.match(re) != null || txt2.match(re) != null){
				$(this).show();
			}else{
				$(this).hide();
			}
		});
	});
});