$(function(){
	$('.search-btn').on("click",function(){
		const re = new RegExp($('.search-txt').val());
		$('.index_table tbody tr').each(function(){
			const txt = $(this).find("td:eq(1)").find("p:eq(0)").html();
      const txt2 = $(this).find("td:eq(1)").find("p:eq(1)").find("span").html();
			if(txt.match(re) != null || txt2.match(re) != null){
				$(this).show();
			}else{
				$(this).hide();
			}
		});
	});
});