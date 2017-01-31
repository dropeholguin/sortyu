function importInstagram() {
  $('#import_instagram').click(function() {  
  	var selected = new Array();
   	$("input:checkbox[name=photo_instagram]:checked").each(function(){
    	selected.push($(this).val())
		});

		$.ajax({
      url: "/photos/create_import_instagram",
      type: "POST",
      data: { photos: selected }
    });
  });
}

$(document).on('turbolinks:load', importInstagram);

function importFacebook() {
  $('#import_facebook').click(function() {  
    var selected = new Array();
    $("input:checkbox[name=photo_facebook]:checked").each(function(){
      selected.push($(this).val())
    });

    $.ajax({
      url: "/photos/create_import_facebook",
      type: "POST",
      data: { photos: selected }
    });
  });
}

$(document).on('turbolinks:load', importFacebook);
