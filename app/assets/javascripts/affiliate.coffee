check_select_affiliate = ->
  $('#affiliate').click ->
    if $(this).is(':checked')
     	$('#user_url').show()
    else
    	$("#user_url").hide()



$(document).on 'turbolinks:load', check_select_affiliate