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

payPhotos = ->
	$('#pay-multiple-photos').click ->
    selected = new Array
    $('input:checkbox[name=pay_photo]:checked').each ->
      selected.push $(this).val()
    
    $.ajax
      url: '/pay_photos'
      type: 'POST'
      data: photo_ids: selected

$(document).on 'turbolinks:load', ->
	selectPayPhotos()

$(document).ready payPhotos
$(document).on 'turbolinks:load', ->
	payPhotos()