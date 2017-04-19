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

destroyPhotos = ->
  $('#destroy-photos').click ->
    selected = new Array
    $('input:checkbox[name=photo]:checked').each ->
      selected.push $(this).val()
    
    $.ajax
      url: '/destroy_photos'
      type: 'DELETE'
      data: photo_ids: selected

editPhotos = ->
  $('#edit-photos').click ->
    selected = new Array
    $('input:checkbox[name=photo]:checked').each ->
      selected.push $(this).val()
    
    $.ajax
      url: '/edit_photos'
      type: 'POST'
      data: photo_ids: selected

$(document).on 'turbolinks:load', ->
	selectPhotos()

$(document).ready destroyPhotos
$(document).ready editPhotos

$(document).on 'turbolinks:load', ->
	destroyPhotos()
	editPhotos()
