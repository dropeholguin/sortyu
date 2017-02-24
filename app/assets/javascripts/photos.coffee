# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
loadPhotoToSort = ->
	if $('#sorting-principal').length > 0
		photoIds = readCookie('photos_queue').split("-")
		if photoIds.length > 0 and photoIds[0] != ""
			photoToSortId = photoIds.splice(0, 1)
			deleteCookie('photos_queue')
			createCookie('photos_queue', photoIds.join("-"), 1)
			$.ajax 'photos/load_photo_to_sort',
			type: 'GET',
			dataType: 'script',
			data: {
				photo_id: photoToSortId[0]
			},
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("AJAX Error: #{textStatus}")
			success: (data, textStatus, jqXHR) ->
				console.log("Sorting photo_id sent correctly! -> #{photoToSortId[0]}")
			complete: (jqXHR, textStatus) ->
				appendSortingElements()
				setTimeout("window.LocalTracker.performTracking()", 1000)
		else
			$.ajax 'photos/reaload_photos_queue',
			type: 'GET',
			dataType: 'script',
			data: {},
			error: (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error: #{textStatus}"
			success: (data, textStatus, jqXHR) ->
				console.log "Photos queue reloaded successfully!"
				if readCookie('photos_queue').length > 0
					loadPhotoToSort()

updatePhotoToSortedState = ->
	photoId = $('#next-sort').data('photo_id')
	#Here you also need to save sorting data
	$.ajax 'photos/update_photo_to_sorted_state',
	type: 'PATCH',
	dataType: 'script',
	data: {
		photo_id: photoId
	},
	error: (jqXHR, textStatus, errorThrown) ->
		console.log("AJAX Error: #{textStatus}")
	success: (data, textStatus, jqXHR) ->
		console.log("Photo updated successfully!")

createSortings = ->
	sortings = []
	$(".rect-clicked").each (index, element) ->
		sortings.push element.id
	photoId = $('#next-sort').data('photo_id')
	$.ajax 'photos/create_sortings',
	type: 'POST',
	dataType: 'script',
	data: {
		photo_id: photoId, sortings: sortings
	},
	error: (jqXHR, textStatus, errorThrown) ->
		console.log("AJAX Error: #{textStatus}")
	success: (data, textStatus, jqXHR) ->
		console.log("Create sorting successfully!")

showInfo = ->
	photoId = $('#next-sort').data('photo_id')
	$.ajax 'photos/info_sorting',
	type: 'POST',
	dataType: 'script',
	data: {
		photo_id: photoId
	},
	error: (jqXHR, textStatus, errorThrown) ->
		console.log("AJAX Error: #{textStatus}")
	success: (data, textStatus, jqXHR) ->
		console.log("Show info successfully!")

$(document).on 'turbolinks:load', ->
	if $('#sorting-principal').length > 0
		loadPhotoToSort()
		if $('.photo-stadistic').length == 0
			$('#next-sort').on 'click', (event) ->
				console.log 'Click first time "next"'
				createSortings()
				showInfo()
				showPhotoStadistics()
				$('#next-sort').unbind()
				$('#next-sort').on 'click', (event) ->
					console.log 'Click second time "next"'
					updatePhotoToSortedState()
					removePhotoStadistics()
					removeSortingElements()
					loadPhotoToSort()

