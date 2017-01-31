function socialSharedButton() {
  	$('.social-share-button').click(function(){
  		var photo_id = $("#photo-i").data('photo');
  		$.ajax({
	      url: "/photos/"+ photo_id +"/shared_times",
	      type: "PATCH"
    	});
		});
}

$(document).ready(socialSharedButton);
$(document).on('turbolinks:load', socialSharedButton);
