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
				loadSectionsToSort(photoToSortId[0])

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

loadSectionsToSort = (photoId)->
	$.ajax 'photos/load_sections_to_sort',
	type: 'GET',
	dataType: 'json',
	data: {
		photo_id: photoId
	},
	error: (jqXHR, textStatus, errorThrown) ->
		console.log("AJAX Error: #{textStatus}")
	success: (data, textStatus, jqXHR) ->
		console.log data.sections
		console.log("Loaded sorting sections")
		window.LocalPloter.performPlot(data.sections)


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

getParameterByName = (name, url) ->
	if !url
		url = window.location.href
	name = name.replace(/[\[\]]/g, '\\$&')
	regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)')
	results = regex.exec(url)
	if !results
		return null
	if !results[2]
		return ''
	decodeURIComponent results[2].replace(/\+/g, ' ')

#Save sections at edit sections page
saveSections = ->
	if $('#photo-editor #canvas').length > 0
		parameter = getParameterByName('photo_id', window.location.href)
		$.ajax '/photos/load_sections_tracker',
		type: 'GET',
		dataType: 'script',
		data: {
			photo_id: parameter
		},
		error: (jqXHR, textStatus, errorThrown) ->
			console.log("AJAX Error: #{textStatus}")
		success: (data, textStatus, jqXHR) ->
			#Running Tracker at load_sections_tracker.js.erb
			
		$('#save-sections').on 'click', ->
			sections = []
			$(".rect").each (index, element) ->
				x = $(element).data('x')
				y = $(element).data('y')
				if typeof x == 'undefined'
					x = 0
				if typeof y == 'undefined'
					y = 0
				sectionsData = 
					'top': parseFloat(element.style.top)
					'left': parseFloat(element.style.left)
					'width': element.style.width
					'translateX': x
					'translateY': y
				if element.style.height == ''
					sectionsData["height"] = '44'
				else
					sectionsData["height"] = parseFloat(element.style.height)

				sections.push sectionsData
			
			photoId = $('#save-sections').data('photo-id')
			console.log sections
			$.ajax '/photos/save_sections',
			type: 'POST',
			dataType: 'script',
			data: {
				photo_id: photoId, sections: sections
			},
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("AJAX Error: #{textStatus}")
			success: (data, textStatus, jqXHR) ->
				console.log("Photo edit sections saved successfully!")
				importedPhotoIds = readCookie('import_queue').split("-")
				if importedPhotoIds.length > 0 and importedPhotoIds[0] != ""
					photoToEditSectionsId = importedPhotoIds.splice(0, 1)
					deleteCookie('photos_queue')
					createCookie('photos_queue', importedPhotoIds.join("-"), 1)
					console.log "dsafdfasdfasdf"
					window.location.replace("/photos/#{photoToEditSectionsId}/edit")
				else
					window.location.replace('/profile/show')


hide_results = ->
	if $('input#hide_results').length > 0
		$.ajax '/users/hide_results',
		type: 'PATCH',
		dataType: 'script',
		data: {},
		error: (jqXHR, textStatus, errorThrown) ->
			console.log("AJAX Error: #{textStatus}")
		success: (data, textStatus, jqXHR) ->
	
	

$(document).on 'turbolinks:load', ->
	changeActiveState()
	saveSections()
	hide_results()
		
	
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
