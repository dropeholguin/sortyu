# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.photoStats ?= {}
window.sortingEffects ?= {}

window.photoStats.show = ->
	photoId = $('#next-sort').data('photo_id')
	$.ajax 'photos/load_sorting_stats',
	type: 'GET',
	dataType: 'script',
	data: {
		photo_id: photoId
	},
	error: (jqXHR, textStatus, errorThrown) ->
		console.log("AJAX Error: #{textStatus}")
	success: (data, textStatus, jqXHR) ->
		console.log("Stadistics shown successfully!")
		$('#next-sort').show()
		$('#loading_text').hide()

window.sortingEffects.load = ->
	loadPhotoToSort()


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
		setTimeout("window.photoStats.show()", 2000)

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
		computeSortingStats()

computeSortingStats = ->
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
		console.log("Sorting stats computed successfully!")
		updatePhotoToSortedState()

finishSorting = ->
	if areAllSectionsClicked()
		removePhotoStadistics()
		removeSortingElements()
		loadPhotoToSort()
	else if not startedSorting()
		removeSortingElements()
		loadPhotoToSort()
	else
		alert("Finish your sorting!")

#checks if all rectangles are clicked
areAllSectionsClicked = ->
	if $(".rect-clicked").length == $(".rect").length
		return true
	else
		return false

#checks if the user started sorting
startedSorting = ->
	if $(".rect-clicked").length > 0
		return true
	else
		return false

#changes active state in section editor
changeActiveState = ->
	if $('#photo-editor').length > 0
		$('#pencil').on 'click', ->
			$('#pencil').addClass('active')
			$('#eraser').removeClass('active')

		$('#eraser').on 'click', ->
			$('#eraser').addClass('active')
			$('#pencil').removeClass('active')

$(document).on 'turbolinks:load', ->
	changeActiveState()
		
	

$(document).on 'turbolinks:load', ->
	if $('#sorting-principal').length > 0
		loadPhotoToSort()

		$(document).on 'click', '.rect', (event) ->
			if areAllSectionsClicked()
				console.log 'All sections are clicked -> Proceed!'
				$('#next-sort').hide()
				$('#photo-stadistic-container').html('<h3 id="loading_text">Loading...</h3>')
				createSortings()
			else
				console.log "Don't do anything yet, not all sections clicked."

		$('#next-sort').on 'click', (event) ->
			finishSorting()
			
		$('#photo-container').on 'click', (event) ->
			if areAllSectionsClicked() and $('.photo-stadistic').length > 0
				finishSorting()
