selectPhotos = ->
	if $('#remove-photos').length > 0
		$('input:checkbox').hide()
		$('#remove-photos img').on 'click', ->
			$imgId = $(this).attr('id')
			$checkbox = $('input[value="'+$imgId+'"]')

			if ($(this).attr('class') == 'highlight')
			 	$(this).removeClass("highlight")
			 	$checkbox.prop('checked', false)
			else
			 	$(this).attr('class','highlight')
			 	$checkbox.prop('checked', true)


$(document).on 'turbolinks:load', ->
	selectPhotos()