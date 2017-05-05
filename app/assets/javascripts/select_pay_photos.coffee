selectPayPhotos = ->
	if $('#pay-photos').length > 0
		$('input:checkbox').hide()
		$('#pay-photos img').on 'click', ->
			$imgId = $(this).attr('id')
			$checkbox = $('input[value="'+$imgId+'"]')

			if ($(this).attr('class') == 'highlight')
			 	$(this).removeClass("highlight")
			 	$checkbox.prop('checked', false)
			else
			 	$(this).attr('class','highlight')
			 	$checkbox.prop('checked', true)

selectPhotos = ->
	if $('#select-photos').length > 0
		$('input:checkbox').hide()
		$('#select-photos img').on 'click', ->
			$imgId = $(this).attr('id')
			$checkbox = $('input[value="'+$imgId+'"]')

			if ($(this).attr('class') == 'highlight')
			 	$(this).removeClass("highlight")
			 	$checkbox.prop('checked', false)
			else
			 	$(this).attr('class','highlight')
			 	$checkbox.prop('checked', true)


payPhotos = ->
	$('#pay-multiple-photos').click ->
    selected = new Array
    noSelected = new Array
    $('input:checkbox[name=pay_photo]').each ->
      	if $(this).is(":checked")
      		selected.push $(this).val()
      	else
      		noSelected.push $(this).val()
    
    $.ajax
      url: '/pay_photos'
      type: 'POST'
      data: photo_ids: selected, photo_ids_no_selected: noSelected

uploadPhotos = ->
	$('#select-multiple-photos').click ->
    selected = new Array
    noSelected = new Array
    $('input:checkbox[name=select_photo]').each ->
    	if $(this).is(":checked")
      		selected.push $(this).val()
      	else
      		noSelected.push $(this).val()
    
    $.ajax
      url: '/photos/upload_photos'
      type: 'POST'
      data: photo_ids: selected, photo_ids_no_selected: noSelected

$(document).on 'turbolinks:load', ->
	selectPayPhotos()
	selectPhotos()

$(document).ready payPhotos
$(document).ready uploadPhotos
$(document).on 'turbolinks:load', ->
	payPhotos()
	uploadPhotos()